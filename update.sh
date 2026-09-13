#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

release="$(curl -fsSL "https://api.github.com/repos/Anuken/Mindustry/releases/latest")"

version="$(echo "$release" | jq -r .tag_name | sed 's/^v//')"
download_url="$(echo "$release" | jq -r '.assets[] | select(.name == "Mindustry.jar") | .browser_download_url')"
safe_version="$(echo "$version" | tr '.' '_')"
target_file="packages/mindustry-bin-${safe_version}.nix"

if [ -f "$target_file" ]; then
  echo "==> [$version] already exists" >&2
  exit 0
fi

echo "==> [$version] $download_url" >&2
hash="$(nix store prefetch-file --json "$download_url" | jq -r .hash)"
echo "    -> $hash" >&2

sed -e "s|@VERSION@|${version}|g" -e "s|@HASH@|${hash}|g" template.nix > "$target_file"
echo "==> generated $target_file" >&2

git add "$target_file"
git commit -m "add Mindustry $version"
git push
