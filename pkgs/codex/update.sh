#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE_FILE="$SCRIPT_DIR/package.nix"

latest_release_url="https://github.com/openai/codex/releases/latest"
if ! latest_url=$(curl -fsSIL -o /dev/null -w '%{url_effective}' "$latest_release_url"); then
  echo "Failed to fetch latest codex release: $latest_release_url" >&2
  exit 1
fi

LATEST="${latest_url##*/}"
LATEST="${LATEST#rust-v}"

if [ -z "$LATEST" ] || [ "$LATEST" = "latest" ]; then
  echo "Failed to determine latest codex version from: $latest_url" >&2
  exit 1
fi

CURRENT=$(grep -oP 'version = "\K[^"]+' "$PACKAGE_FILE")

if [ "$LATEST" = "$CURRENT" ]; then
  echo "Already at latest version: $CURRENT"
  exit 0
fi

echo "Updating codex: $CURRENT -> $LATEST"

declare -A HASHES
for target in x86_64-unknown-linux-musl aarch64-unknown-linux-musl; do
  url="https://github.com/openai/codex/releases/download/rust-v${LATEST}/codex-${target}.tar.gz"
  echo "  fetching $target..."
  if ! raw=$(nix-prefetch-url "$url"); then
    echo "Failed to fetch codex asset: $url" >&2
    exit 1
  fi
  HASHES[$target]=$(nix hash convert --hash-algo sha256 --to sri "$raw")
done

TMP_PACKAGE_FILE=$(mktemp)
cp "$PACKAGE_FILE" "$TMP_PACKAGE_FILE"
trap 'rm -f "$TMP_PACKAGE_FILE"' EXIT

sed -i "s|version = \"$CURRENT\"|version = \"$LATEST\"|" "$TMP_PACKAGE_FILE"

for target in "${!HASHES[@]}"; do
  sed -i "/target = \"$target\";/,/hash = / s|hash = \"[^\"]*\";|hash = \"${HASHES[$target]}\";|" "$TMP_PACKAGE_FILE"
done

mv "$TMP_PACKAGE_FILE" "$PACKAGE_FILE"

echo "Updated pkgs/codex/package.nix to $LATEST"
