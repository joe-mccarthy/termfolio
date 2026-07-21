#!/usr/bin/env bash

set -euo pipefail
export LC_ALL=C

fail() {
  printf 'theme-test-error: %s\n' "$1" >&2
  exit 1
}

for required_command in cp git grep hugo ln mkdir mktemp mv sed; do
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

render_site() {
  local source_dir=$1
  local destination_dir=$2
  local cache_dir=$3
  local panic_on_warning=$4
  local hugo_args=(
    --source "$source_dir"
    --themesDir "$test_root/themes"
    --theme termfolio
    --destination "$destination_dir"
    --gc
    --minify
    --noBuildLock
  )

  if [[ "$panic_on_warning" == true ]]; then
    hugo_args+=(--panicOnWarning)
  fi

  HUGO_CACHEDIR="$cache_dir" hugo "${hugo_args[@]}"
}

output_dir="$test_root/public"
render_site \
  "$repository_root/example-site" \
  "$output_dir" \
  "$test_root/cache" \
  true

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

legacy_source_dir="$test_root/legacy-site"
legacy_output_dir="$test_root/legacy-public"
legacy_config="$legacy_source_dir/config.yaml"
cp -R "$repository_root/example-site" "$legacy_source_dir"
sed 's/^defaultContentLanguage:/languageCode:/' \
  "$legacy_config" >"$legacy_config.tmp"
mv "$legacy_config.tmp" "$legacy_config"

grep -Fq 'languageCode: en-gb' "$legacy_config" ||
  fail 'legacy fixture does not declare languageCode="en-gb"'
if grep -Eq '^defaultContentLanguage:' "$legacy_config"; then
  fail 'legacy fixture still declares defaultContentLanguage'
fi

# Hugo 0.158.0 and newer warn about languageCode while loading configuration,
# before the theme can render the compatible language value.
render_site \
  "$legacy_source_dir" \
  "$legacy_output_dir" \
  "$test_root/legacy-cache" \
  false
grep -Eq '<html lang="?en-gb"?' "$legacy_output_dir/index.html" ||
  fail 'languageCode-only fixture does not declare lang="en-gb"'

printf 'Verified Termfolio with %s\n' "$hugo_version"
