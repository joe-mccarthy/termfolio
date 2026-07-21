#!/usr/bin/env bash

set -euo pipefail
export LC_ALL=C

usage() {
  cat <<'USAGE'
Usage:
  validate-release-candidate.sh \
    --tag TAG \
    --expected-sha SHA \
    --main-ref REF \
    --repository OWNER/REPO \
    --notes-dir DIR \
    --changelog PATH

Validate an immutable GitHub Release candidate without modifying the repository
or GitHub. Success is emitted as one JSON object on stdout; failures are emitted
as one JSON object on stderr.
USAGE
}

fail() {
  local message=$1

  if command -v jq >/dev/null 2>&1; then
    jq -cn --arg message "$message" \
      '{status:"error",message:$message}' >&2
  else
    printf 'release-candidate-error: %s\n' "$message" >&2
  fi
  exit 1
}

safe_relative_path() {
  local path=$1

  [[ -n "$path" ]] &&
    [[ "$path" =~ ^[A-Za-z0-9._/-]+$ ]] &&
    [[ "$path" != /* ]] &&
    [[ "$path" != "." ]] &&
    [[ "$path" != ".." ]] &&
    [[ "$path" != ../* ]] &&
    [[ "$path" != */../* ]] &&
    [[ "$path" != */.. ]]
}

tag=
expected_sha=
main_ref=
repository=
notes_dir=
changelog_path=

while (( $# > 0 )); do
  case "$1" in
    --tag)
      (( $# >= 2 )) || fail "--tag requires a value"
      tag=$2
      shift 2
      ;;
    --expected-sha)
      (( $# >= 2 )) || fail "--expected-sha requires a value"
      expected_sha=$2
      shift 2
      ;;
    --main-ref)
      (( $# >= 2 )) || fail "--main-ref requires a value"
      main_ref=$2
      shift 2
      ;;
    --repository)
      (( $# >= 2 )) || fail "--repository requires a value"
      repository=$2
      shift 2
      ;;
    --notes-dir)
      (( $# >= 2 )) || fail "--notes-dir requires a value"
      notes_dir=$2
      shift 2
      ;;
    --changelog)
      (( $# >= 2 )) || fail "--changelog requires a value"
      changelog_path=$2
      shift 2
      ;;
    --help)
      usage
      exit 0
      ;;
    *)
      fail "unknown argument: $1"
      ;;
  esac
done

[[ -n "$tag" ]] || fail "--tag is required"
[[ -n "$expected_sha" ]] || fail "--expected-sha is required"
[[ -n "$main_ref" ]] || fail "--main-ref is required"
[[ -n "$repository" ]] || fail "--repository is required"
[[ -n "$notes_dir" ]] || fail "--notes-dir is required"
[[ -n "$changelog_path" ]] || fail "--changelog is required"

for required_command in git gh jq grep mktemp; do
  command -v "$required_command" >/dev/null 2>&1 ||
    fail "required command is unavailable: $required_command"
done

tag_pattern='^v(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)(-(alpha|beta|rc)\.[1-9][0-9]*)?$'
[[ "$tag" =~ $tag_pattern ]] ||
  fail "tag must match vMAJOR.MINOR.PATCH or vMAJOR.MINOR.PATCH-(alpha|beta|rc).N without leading zeroes"

[[ "$expected_sha" =~ ^[0-9a-f]{40}$ ]] ||
  fail "--expected-sha must be a complete lowercase 40-character Git SHA"

[[ "$repository" =~ ^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$ ]] ||
  fail "--repository must use OWNER/REPO form"

[[ "$main_ref" =~ ^[A-Za-z0-9._/-]+$ ]] ||
  fail "--main-ref contains unsupported characters"

safe_relative_path "$notes_dir" ||
  fail "--notes-dir must be a safe repository-relative path"
safe_relative_path "$changelog_path" ||
  fail "--changelog must be a safe repository-relative path"

[[ -n "${GH_TOKEN:-}" ]] ||
  fail "GH_TOKEN is required for remote tag and release checks"

git rev-parse --git-dir >/dev/null 2>&1 ||
  fail "current directory is not a Git repository"

if [[ -n "$(git status --porcelain=v1 --untracked-files=all)" ]]; then
  fail "working tree must be clean before publication validation"
fi

if ! head_sha=$(git rev-parse --verify HEAD 2>/dev/null); then
  fail "repository has no committed HEAD"
fi
[[ "$head_sha" == "$expected_sha" ]] ||
  fail "checked-out HEAD does not match the workflow event SHA"

tag_ref="refs/tags/$tag"
git show-ref --verify --quiet "$tag_ref" ||
  fail "local tag does not exist: $tag"

tag_type=$(git cat-file -t "$tag_ref")
[[ "$tag_type" == "tag" ]] ||
  fail "release tags must be annotated; lightweight tag found: $tag"

local_tag_object_sha=$(git rev-parse "$tag_ref")
target_sha=$(git rev-parse "${tag_ref}^{commit}")
[[ "$target_sha" == "$expected_sha" ]] ||
  fail "local tag target does not match the workflow event SHA"

if ! main_sha=$(git rev-parse --verify "${main_ref}^{commit}" 2>/dev/null); then
  fail "main reference is unavailable: $main_ref"
fi
git merge-base --is-ancestor "$target_sha" "$main_sha" ||
  fail "tag target is not reachable from $main_ref"

notes_dir=${notes_dir%/}
notes_file="${notes_dir}/${tag}.md"
if ! target_notes_blob=$(git rev-parse --verify "${target_sha}:${notes_file}" 2>/dev/null); then
  fail "release notes are missing from the tagged commit: $notes_file"
fi
[[ -f "$notes_file" ]] ||
  fail "release notes are missing from the checked-out worktree: $notes_file"
worktree_notes_blob=$(git hash-object -- "$notes_file")
[[ "$worktree_notes_blob" == "$target_notes_blob" ]] ||
  fail "checked-out release notes differ from the tagged content: $notes_file"
notes_content=$(git show "${target_sha}:${notes_file}")
[[ "$notes_content" =~ [^[:space:]] ]] ||
  fail "release notes must contain non-whitespace content: $notes_file"

if ! git cat-file -e "${target_sha}:${changelog_path}" 2>/dev/null; then
  fail "changelog is missing from the tagged commit: $changelog_path"
fi
changelog_content=$(git show "${target_sha}:${changelog_path}")
version=${tag#v}
escaped_version=${version//./\\.}
changelog_heading="^## \\[${escaped_version}\\] - [0-9]{4}-[0-9]{2}-[0-9]{2}$"
grep -Eq "$changelog_heading" <<<"$changelog_content" ||
  fail "changelog must contain a dated bracketed heading for version $version"

if ! remote_ref_json=$(
  gh api "repos/${repository}/git/ref/tags/${tag}" 2>/dev/null
); then
  fail "remote tag is unavailable in $repository: $tag"
fi

remote_object_type=$(jq -er '.object.type' <<<"$remote_ref_json") ||
  fail "remote tag response did not include an object type"
remote_object_sha=$(jq -er '.object.sha' <<<"$remote_ref_json") ||
  fail "remote tag response did not include an object SHA"
[[ "$remote_object_type" == "tag" ]] ||
  fail "remote release tag must be annotated: $tag"
[[ "$remote_object_sha" == "$local_tag_object_sha" ]] ||
  fail "remote tag object differs from the validated local tag object"

if ! remote_tag_json=$(
  gh api "repos/${repository}/git/tags/${remote_object_sha}" 2>/dev/null
); then
  fail "annotated remote tag object cannot be inspected: $remote_object_sha"
fi

remote_target_type=$(jq -er '.object.type' <<<"$remote_tag_json") ||
  fail "remote annotated tag did not include a target type"
remote_target_sha=$(jq -er '.object.sha' <<<"$remote_tag_json") ||
  fail "remote annotated tag did not include a target SHA"
[[ "$remote_target_type" == "commit" ]] ||
  fail "annotated release tag must point directly to a commit"
[[ "$remote_target_sha" == "$target_sha" ]] ||
  fail "remote tag target differs from the validated commit"

release_probe=$(mktemp)
cleanup() {
  rm -f -- "$release_probe"
}
trap cleanup EXIT

if gh api --include \
  "repos/${repository}/releases/tags/${tag}" \
  >"$release_probe" 2>&1; then
  fail "a GitHub Release already exists for tag $tag"
fi
grep -Eq '^HTTP/[0-9.]+ 404([[:space:]]|$)' "$release_probe" ||
  fail "could not establish that the GitHub Release is absent"

if [[ "$version" == *-* ]]; then
  prerelease=true
  channel=prerelease
else
  prerelease=false
  channel=stable
fi

jq -cn \
  --arg repository "$repository" \
  --arg tag "$tag" \
  --arg version "$version" \
  --arg channel "$channel" \
  --arg tag_object_sha "$local_tag_object_sha" \
  --arg target_sha "$target_sha" \
  --arg main_ref "$main_ref" \
  --arg main_sha "$main_sha" \
  --arg notes_file "$notes_file" \
  --arg changelog "$changelog_path" \
  --argjson prerelease "$prerelease" \
  '{
    status: "ready",
    repository: $repository,
    tag: $tag,
    version: $version,
    channel: $channel,
    prerelease: $prerelease,
    tag_object_sha: $tag_object_sha,
    target_sha: $target_sha,
    main_ref: $main_ref,
    main_sha: $main_sha,
    notes_file: $notes_file,
    changelog: $changelog,
    publication_destination: "github-release",
    expected_assets: [
      "github-source-archive-zip",
      "github-source-archive-tar-gz"
    ]
  }'
