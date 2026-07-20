#!/usr/bin/env bash

set -euo pipefail
export LC_ALL=C

fail() {
  printf 'release-validator-test-error: %s\n' "$1" >&2
  exit 1
}

for required_command in cp git jq mktemp sed; do
  command -v "$required_command" >/dev/null 2>&1 ||
    fail "required command is unavailable: $required_command"
done

script_directory=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
validator="$script_directory/validate-release-candidate.sh"
[[ -x "$validator" ]] || fail "validator is not executable: $validator"

test_root=$(mktemp -d "${TMPDIR:-/tmp}/termfolio-release-tests.XXXXXX")
cleanup() {
  if [[ -n "${test_root:-}" ]] && [[ -d "$test_root" ]]; then
    rm -rf -- "$test_root"
  fi
}
trap cleanup EXIT

mock_bin="$test_root/bin"
base_repository="$test_root/base"
mkdir -p "$mock_bin" "$base_repository"

cat >"$mock_bin/gh" <<'MOCK_GH'
#!/usr/bin/env bash
set -euo pipefail

[[ "${1:-}" == "api" ]] || exit 2
shift

include=false
if [[ "${1:-}" == "--include" ]]; then
  include=true
  shift
fi

endpoint=${1:-}
case "$endpoint" in
  repos/*/git/ref/tags/*)
    [[ "${MOCK_REMOTE_REF_STATE:-present}" == "present" ]] || exit 1
    jq -cn \
      --arg type "${MOCK_REMOTE_OBJECT_TYPE:-tag}" \
      --arg sha "${MOCK_REMOTE_OBJECT_SHA:?}" \
      '{object:{type:$type,sha:$sha}}'
    ;;
  repos/*/git/tags/*)
    [[ "${MOCK_REMOTE_TAG_STATE:-present}" == "present" ]] || exit 1
    jq -cn \
      --arg type "${MOCK_REMOTE_TARGET_TYPE:-commit}" \
      --arg sha "${MOCK_REMOTE_TARGET_SHA:?}" \
      '{object:{type:$type,sha:$sha}}'
    ;;
  repos/*/releases/tags/*)
    [[ "$include" == "true" ]] || exit 2
    case "${MOCK_RELEASE_STATE:-absent}" in
      absent)
        printf 'HTTP/2.0 404 Not Found\n' >&2
        exit 1
        ;;
      exists)
        printf '{"tag_name":"test"}\n'
        ;;
      error)
        printf 'HTTP/2.0 500 Internal Server Error\n' >&2
        exit 1
        ;;
      *)
        exit 2
        ;;
    esac
    ;;
  *)
    exit 2
    ;;
esac
MOCK_GH
chmod 755 "$mock_bin/gh"

git init --quiet --initial-branch=main "$base_repository"
(
  cd "$base_repository"
  git config user.email release-tests@example.invalid
  git config user.name "Release Validator Tests"
  git config commit.gpgSign false
  git config tag.gpgSign false
  mkdir -p release-notes
  printf '# Test release notes\n' >release-notes/v1.0.0.md
  {
    printf '# Changelog\n\n'
    printf '## [1.0.0] - 2026-07-20\n'
  } >CHANGELOG.md
  git add CHANGELOG.md release-notes/v1.0.0.md
  git commit --quiet -m "Prepare fixture"
  git tag --annotate v1.0.0 --message "Fixture v1.0.0"
  git update-ref refs/remotes/origin/main HEAD
)

CASE_TAG=
CASE_EXPECTED_SHA=
CASE_MAIN_REF=
CASE_REMOTE_REF_STATE=
CASE_REMOTE_TAG_STATE=
CASE_REMOTE_OBJECT_TYPE=
CASE_REMOTE_OBJECT_SHA=
CASE_REMOTE_TARGET_TYPE=
CASE_REMOTE_TARGET_SHA=
CASE_RELEASE_STATE=
CASE_UNSET_GH_TOKEN=

retag_head() {
  git tag --delete "$CASE_TAG" >/dev/null 2>&1 || true
  git tag --annotate "$CASE_TAG" --message "Fixture $CASE_TAG"
}

setup_default() {
  :
}

setup_prerelease() {
  git mv release-notes/v1.0.0.md release-notes/v1.0.0-rc.1.md
  sed -i 's/^## \[1\.0\.0\]/## [1.0.0-rc.1]/' CHANGELOG.md
  git add CHANGELOG.md
  git commit --quiet -m "Prepare prerelease fixture"
  git tag --delete v1.0.0 >/dev/null
  CASE_TAG=v1.0.0-rc.1
  git tag --annotate "$CASE_TAG" --message "Fixture $CASE_TAG"
  git update-ref refs/remotes/origin/main HEAD
}

setup_invalid_tag() {
  CASE_TAG=v01.0.0
}

setup_lightweight_tag() {
  git tag --delete "$CASE_TAG" >/dev/null
  git tag --no-sign "$CASE_TAG"
}

setup_wrong_expected_sha() {
  CASE_EXPECTED_SHA=0000000000000000000000000000000000000000
}

setup_wrong_tag_target() {
  printf 'second commit\n' >second.txt
  git add second.txt
  git commit --quiet -m "Advance HEAD without moving tag"
  git update-ref refs/remotes/origin/main HEAD
}

setup_dirty_worktree() {
  printf 'untracked\n' >dirty.txt
}

setup_missing_token() {
  CASE_UNSET_GH_TOKEN=true
}

setup_missing_notes() {
  git rm --quiet release-notes/v1.0.0.md
  git commit --quiet -m "Remove notes"
  retag_head
  git update-ref refs/remotes/origin/main HEAD
}

setup_empty_notes() {
  : >release-notes/v1.0.0.md
  git add release-notes/v1.0.0.md
  git commit --quiet -m "Empty notes"
  retag_head
  git update-ref refs/remotes/origin/main HEAD
}

setup_drifted_notes() {
  printf '# Drifted notes\n' >release-notes/v1.0.0.md
  git update-index --assume-unchanged release-notes/v1.0.0.md
}

setup_missing_changelog() {
  git rm --quiet CHANGELOG.md
  git commit --quiet -m "Remove changelog"
  retag_head
  git update-ref refs/remotes/origin/main HEAD
}

setup_unbracketed_changelog() {
  sed -i 's/^## \[1\.0\.0\]/## 1.0.0/' CHANGELOG.md
  git add CHANGELOG.md
  git commit --quiet -m "Use unbracketed changelog heading"
  retag_head
  git update-ref refs/remotes/origin/main HEAD
}

setup_tag_not_on_main() {
  local main_sha
  main_sha=$(git rev-parse HEAD)
  printf 'side commit\n' >side.txt
  git add side.txt
  git commit --quiet -m "Create non-main candidate"
  retag_head
  git update-ref refs/remotes/origin/main "$main_sha"
}

setup_remote_ref_missing() {
  CASE_REMOTE_REF_STATE=missing
}

setup_remote_lightweight_tag() {
  CASE_REMOTE_OBJECT_TYPE=commit
}

setup_remote_object_mismatch() {
  CASE_REMOTE_OBJECT_SHA=1111111111111111111111111111111111111111
}

setup_remote_tag_missing() {
  CASE_REMOTE_TAG_STATE=missing
}

setup_remote_target_mismatch() {
  CASE_REMOTE_TARGET_SHA=2222222222222222222222222222222222222222
}

setup_existing_release() {
  CASE_RELEASE_STATE=exists
}

setup_release_probe_error() {
  CASE_RELEASE_STATE=error
}

prepare_case() {
  local setup_function=$1
  local case_repository
  local local_tag_object

  case_repository=$(mktemp -d "$test_root/case.XXXXXX")
  cp -a "$base_repository/." "$case_repository/"
  cd "$case_repository"

  CASE_TAG=v1.0.0
  CASE_EXPECTED_SHA=
  CASE_MAIN_REF=origin/main
  CASE_REMOTE_REF_STATE=present
  CASE_REMOTE_TAG_STATE=present
  CASE_REMOTE_OBJECT_TYPE=tag
  CASE_REMOTE_OBJECT_SHA=
  CASE_REMOTE_TARGET_TYPE=commit
  CASE_REMOTE_TARGET_SHA=
  CASE_RELEASE_STATE=absent
  CASE_UNSET_GH_TOKEN=false

  "$setup_function"

  CASE_EXPECTED_SHA=${CASE_EXPECTED_SHA:-$(git rev-parse HEAD)}
  local_tag_object=$(
    git rev-parse "refs/tags/$CASE_TAG" 2>/dev/null ||
      printf '0000000000000000000000000000000000000000\n'
  )
  CASE_REMOTE_OBJECT_SHA=${CASE_REMOTE_OBJECT_SHA:-$local_tag_object}
  CASE_REMOTE_TARGET_SHA=${CASE_REMOTE_TARGET_SHA:-$(git rev-parse HEAD)}
}

invoke_validator() {
  local -a command=(
    "$validator"
    --tag "$CASE_TAG"
    --expected-sha "$CASE_EXPECTED_SHA"
    --main-ref "$CASE_MAIN_REF"
    --repository test-owner/test-repository
    --notes-dir release-notes
    --changelog CHANGELOG.md
  )
  local -a environment=(
    "PATH=$mock_bin:$PATH"
    "MOCK_REMOTE_REF_STATE=$CASE_REMOTE_REF_STATE"
    "MOCK_REMOTE_TAG_STATE=$CASE_REMOTE_TAG_STATE"
    "MOCK_REMOTE_OBJECT_TYPE=$CASE_REMOTE_OBJECT_TYPE"
    "MOCK_REMOTE_OBJECT_SHA=$CASE_REMOTE_OBJECT_SHA"
    "MOCK_REMOTE_TARGET_TYPE=$CASE_REMOTE_TARGET_TYPE"
    "MOCK_REMOTE_TARGET_SHA=$CASE_REMOTE_TARGET_SHA"
    "MOCK_RELEASE_STATE=$CASE_RELEASE_STATE"
  )

  if [[ "$CASE_UNSET_GH_TOKEN" == "true" ]]; then
    env -u GH_TOKEN "${environment[@]}" "${command[@]}"
  else
    env GH_TOKEN=test-token "${environment[@]}" "${command[@]}"
  fi
}

expect_success() (
  local setup_function=$1
  local expected_channel=$2
  local output

  prepare_case "$setup_function"
  output=$(invoke_validator)
  jq -e \
    --arg tag "$CASE_TAG" \
    --arg channel "$expected_channel" \
    --arg target "$CASE_EXPECTED_SHA" \
    '
      .status == "ready"
      and .tag == $tag
      and .channel == $channel
      and .target_sha == $target
      and .changelog == "CHANGELOG.md"
      and (.notes_file == ("release-notes/" + $tag + ".md"))
    ' <<<"$output" >/dev/null
)

expect_failure() (
  local setup_function=$1
  local expected_message=$2
  local stderr_file
  local stdout_file

  prepare_case "$setup_function"
  stderr_file=$(mktemp "$test_root/stderr.XXXXXX")
  stdout_file=$(mktemp "$test_root/stdout.XXXXXX")

  if invoke_validator >"$stdout_file" 2>"$stderr_file"; then
    printf 'validator unexpectedly succeeded\n' >&2
    return 1
  fi

  jq -e --arg expected "$expected_message" \
    '.status == "error" and (.message | contains($expected))' \
    "$stderr_file" >/dev/null || {
      printf 'expected failure containing: %s\n' "$expected_message" >&2
      printf 'actual stderr: ' >&2
      cat "$stderr_file" >&2
      return 1
    }
)

passed=0
failed=0

run_test() {
  local name=$1
  shift

  if "$@"; then
    printf 'ok - %s\n' "$name"
    ((passed += 1))
  else
    printf 'not ok - %s\n' "$name" >&2
    ((failed += 1))
  fi
}

run_test "accepts a stable annotated candidate" \
  expect_success setup_default stable
run_test "accepts an allowed prerelease candidate" \
  expect_success setup_prerelease prerelease
run_test "rejects an invalid tag" \
  expect_failure setup_invalid_tag "tag must match"
run_test "rejects a lightweight local tag" \
  expect_failure setup_lightweight_tag "release tags must be annotated"
run_test "rejects the wrong workflow SHA" \
  expect_failure setup_wrong_expected_sha "checked-out HEAD does not match"
run_test "rejects a tag targeting another commit" \
  expect_failure setup_wrong_tag_target "local tag target does not match"
run_test "rejects a dirty worktree" \
  expect_failure setup_dirty_worktree "working tree must be clean"
run_test "requires a GitHub token" \
  expect_failure setup_missing_token "GH_TOKEN is required"
run_test "rejects missing release notes" \
  expect_failure setup_missing_notes "release notes are missing from the tagged commit"
run_test "rejects empty release notes" \
  expect_failure setup_empty_notes "release notes must contain non-whitespace"
run_test "rejects drifted checked-out release notes" \
  expect_failure setup_drifted_notes "checked-out release notes differ"
run_test "rejects a missing changelog" \
  expect_failure setup_missing_changelog "changelog is missing from the tagged commit"
run_test "requires a bracketed changelog heading" \
  expect_failure setup_unbracketed_changelog "dated bracketed heading"
run_test "requires the candidate to be on main" \
  expect_failure setup_tag_not_on_main "tag target is not reachable"
run_test "rejects an unavailable remote tag" \
  expect_failure setup_remote_ref_missing "remote tag is unavailable"
run_test "rejects a lightweight remote tag" \
  expect_failure setup_remote_lightweight_tag "remote release tag must be annotated"
run_test "rejects a mismatched remote tag object" \
  expect_failure setup_remote_object_mismatch "remote tag object differs"
run_test "rejects an unavailable remote tag object" \
  expect_failure setup_remote_tag_missing "annotated remote tag object cannot be inspected"
run_test "rejects a mismatched remote target" \
  expect_failure setup_remote_target_mismatch "remote tag target differs"
run_test "rejects an existing GitHub Release" \
  expect_failure setup_existing_release "GitHub Release already exists"
run_test "rejects an inconclusive release probe" \
  expect_failure setup_release_probe_error "could not establish that the GitHub Release is absent"

printf '%s passed; %s failed\n' "$passed" "$failed"
((failed == 0))
