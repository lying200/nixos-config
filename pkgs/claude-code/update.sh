#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_URL="https://downloads.claude.ai/claude-code-releases"

VERSION=$(curl -fsSL "$BASE_URL/latest")
echo "Latest version: $VERSION"

curl -fsSL "$BASE_URL/$VERSION/manifest.json" --output "$SCRIPT_DIR/manifest.json"
echo "Updated manifest.json"
