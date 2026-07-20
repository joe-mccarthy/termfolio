#!/usr/bin/env bash

set -euo pipefail
export LC_ALL=C

fail() {
  printf 'theme-test-error: %s\n' "$1" >&2
  exit 1
}

for required_command in git grep hugo ln mktemp; do
  command -v "$required_command" >/dev/null 2>&1 ||
    fail "required command is unavailable: $required_command"
done

repository_root=$(git rev-parse --show-toplevel)
expected_hugo_version=${1:-}
hugo_version=$(hugo version)

if [[ -n "$expected_hugo_version" ]] &&
  [[ "$hugo_version" != *"v${expected_hugo_version}"* ]]; then
  fail "expected Hugo $expected_hugo_version, found: $hugo_version"
fi

test_root=$(mktemp -d "${TMPDIR:-/tmp}/termfolio-render.XXXXXX")
cleanup() {
  if [[ -n "${test_root:-}" ]] && [[ -d "$test_root" ]]; then
    rm -rf -- "$test_root"
  fi
}
trap cleanup EXIT

mkdir -p "$test_root/themes"
ln -s "$repository_root" "$test_root/themes/termfolio"

output_dir="$test_root/public"
HUGO_CACHEDIR="$test_root/cache" hugo \
  --source "$repository_root/example-site" \
  --themesDir "$test_root/themes" \
  --theme termfolio \
  --destination "$output_dir" \
  --gc \
  --minify \
  --noBuildLock \
  --panicOnWarning

expected_routes=(
  404.html
  index.html
  categories/index.html
  categories/theme-design/index.html
  posts/index.html
  projects/index.html
  search/index.html
  series/index.html
  series/theme-showcase/index.html
  tags/index.html
  tags/hugo/index.html
)

for route in "${expected_routes[@]}"; do
  [[ -f "$output_dir/$route" ]] || fail "rendered route is missing: $route"
done

grep -Eq '<html lang="?en-gb"?' "$output_dir/index.html" ||
  fail 'home page does not declare lang="en-gb"'
grep -Fq '$ ls -la ./categories/' "$output_dir/categories/index.html" ||
  fail 'category index did not use the taxonomy-index layout'
grep -Fq 'Category: Theme Design' \
  "$output_dir/categories/theme-design/index.html" ||
  fail 'category term did not use the taxonomy-term layout'
grep -Fq 'Series: Theme Showcase' \
  "$output_dir/series/theme-showcase/index.html" ||
  fail 'series term did not use the taxonomy-term layout'
grep -Fq 'Tag: Hugo' "$output_dir/tags/hugo/index.html" ||
  fail 'tag term did not use the taxonomy-term layout'

printf 'Verified Termfolio with %s\n' "$hugo_version"
