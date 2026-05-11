#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE_FILE="$SCRIPT_DIR/package.nix"
REPO="farion1231/cc-switch"

latest_release_url="https://github.com/${REPO}/releases/latest"
if ! latest_url=$(curl -fsSIL -o /dev/null -w '%{url_effective}' "$latest_release_url"); then
  echo "Failed to fetch latest cc-switch release: $latest_release_url" >&2
  exit 1
fi

LATEST="${latest_url##*/}"
LATEST="${LATEST#v}"

if [ -z "$LATEST" ] || [ "$LATEST" = "latest" ]; then
  echo "Failed to determine latest cc-switch version from: $latest_url" >&2
  exit 1
fi

CURRENT=$(grep -oP 'version = "\K[^"]+' "$PACKAGE_FILE")

if [ "$LATEST" = "$CURRENT" ]; then
  echo "Already at latest version: $CURRENT"
  exit 0
fi

echo "Updating cc-switch: $CURRENT -> $LATEST"

URL="https://github.com/${REPO}/releases/download/v${LATEST}/CC-Switch-v${LATEST}-Linux-x86_64.AppImage"
RAW_HASH=$(nix-prefetch-url "$URL")
HASH=$(nix hash convert --hash-algo sha256 --to sri "$RAW_HASH")

sed -i "s|version = \"$CURRENT\"|version = \"$LATEST\"|" "$PACKAGE_FILE"
sed -i "s|hash = \"[^\"]*\";|hash = \"$HASH\";|" "$PACKAGE_FILE"

echo "Updated pkgs/cc-switch/package.nix to $LATEST"
