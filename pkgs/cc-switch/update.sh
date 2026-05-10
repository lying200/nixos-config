#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE_FILE="$SCRIPT_DIR/package.nix"
REPO="farion1231/cc-switch"

LATEST=$(curl -fsSL "https://api.github.com/repos/${REPO}/releases" \
  | python3 -c '
import json, sys
for release in json.load(sys.stdin):
    if release.get("prerelease") or release.get("draft"):
        continue
    print(release["tag_name"].removeprefix("v"))
    break
')

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
