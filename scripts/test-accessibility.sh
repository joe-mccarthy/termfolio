#!/usr/bin/env bash

set -euo pipefail
export LC_ALL=C

fail() {
  local message=$1

  printf 'accessibility-test-error: %s\n' "$message" >&2
  exit 1
}

for required_command in curl grep hugo jq ln mkdir mktemp node python3; do
  command -v "$required_command" >/dev/null 2>&1 ||
    fail "required command is unavailable: $required_command"
done

script_directory=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
repository_root=$(cd -- "$script_directory/.." && pwd)
lighthouse="$repository_root/node_modules/.bin/lighthouse"
minimum_score=0.95
server_port=${TERMFOLIO_A11Y_PORT:-4173}

[[ -x "$lighthouse" ]] || fail "Lighthouse is unavailable; run npm ci first"
[[ "$server_port" =~ ^[0-9]+$ ]] || fail "server port must be numeric"

test_root=$(mktemp -d "${TMPDIR:-/tmp}/termfolio-a11y.XXXXXX")
public_dir="$test_root/public"
server_origin="http://127.0.0.1:${server_port}"
themes_dir="$test_root/themes"
server_pid=
cleanup() {
  if [[ -n "${server_pid:-}" ]]; then
    kill "$server_pid" >/dev/null 2>&1 || true
    wait "$server_pid" 2>/dev/null || true
  fi
  if [[ -n "${test_root:-}" ]] && [[ -d "$test_root" ]]; then
    rm -rf -- "$test_root"
  fi
}
trap cleanup EXIT

mkdir -p "$themes_dir"
ln -s "$repository_root" "$themes_dir/termfolio"

HUGO_CACHEDIR="$test_root/hugo-cache" hugo \
  --source "$repository_root/example-site" \
  --themesDir "$themes_dir" \
  --theme termfolio \
  --destination "$public_dir" \
  --baseURL "$server_origin/" \
  --cleanDestinationDir \
  --gc \
  --minify \
  --noBuildLock \
  --panicOnWarning

python3 -m http.server "$server_port" \
  --bind 127.0.0.1 \
  --directory "$public_dir" \
  >"$test_root/server.log" 2>&1 &
server_pid=$!

for _ in {1..20}; do
  if curl --fail --silent --show-error \
    "$server_origin/" >/dev/null 2>&1; then
    break
  fi
  sleep 0.25
done
curl --fail --silent --show-error \
  "$server_origin/" >/dev/null ||
  fail "static server did not start on port $server_port"

home_html="$test_root/home.html"
curl --fail --silent --show-error "$server_origin/" >"$home_html" ||
  fail "home route is unavailable"
grep -Eq 'href="?/css/termfolio\.css"?' "$home_html" ||
  fail "home route does not reference the served theme stylesheet"
curl --fail --silent --show-error \
  "$server_origin/css/termfolio.css" >/dev/null ||
  fail "theme stylesheet is unavailable"

routes=(
  home:/
  posts:/posts/
  projects:/projects/
  search:/search/
)

for route_spec in "${routes[@]}"; do
  name=${route_spec%%:*}
  route=${route_spec#*:}
  report="$test_root/${name}.json"

  curl --fail --silent --show-error \
    "$server_origin${route}" >/dev/null ||
    fail "audited route is unavailable: $route"

  "$lighthouse" \
    "$server_origin${route}" \
    --chrome-flags="--headless=new --no-sandbox --disable-dev-shm-usage" \
    --only-categories=accessibility \
    --output=json \
    --output-path="$report" \
    --quiet

  score=$(jq -er '.categories.accessibility.score' "$report") ||
    fail "Lighthouse did not return an accessibility score for $route"
  jq -e --argjson minimum "$minimum_score" \
    '.categories.accessibility.score >= $minimum' "$report" >/dev/null ||
    fail "accessibility score for $route was $score; expected at least $minimum_score"

  printf 'Accessibility score %s: %s\n' "$route" "$score"
done
