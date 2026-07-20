#!/usr/bin/env bash

set -euo pipefail

script_directory=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
repository_root=$(cd -- "$script_directory/.." && pwd)
link_checker="$repository_root/node_modules/.bin/markdown-link-check"

[[ -x "$link_checker" ]] || {
  printf '%s\n' "link-check-error: markdown-link-check is unavailable; run npm ci first" >&2
  exit 1
}

documents=(
  "$repository_root/CHANGELOG.md"
  "$repository_root/README.md"
  "$repository_root/.github"
  "$repository_root/docs"
)

for optional_path in \
  "$repository_root/RELEASING.md" \
  "$repository_root/release-notes"; do
  [[ ! -e "$optional_path" ]] || documents+=("$optional_path")
done

"$link_checker" "${documents[@]}" \
  --config "$repository_root/.markdown-link-check.json" \
  --quiet
