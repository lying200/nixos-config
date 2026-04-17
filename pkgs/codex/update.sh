#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE_FILE="$SCRIPT_DIR/package.nix"

LATEST=$(curl -fsSL "https://api.github.com/repos/openai/codex/releases" \
  | python3 -c "
import json, sys
for r in json.load(sys.stdin):
    tag = r['tag_name']
    if 'alpha' not in tag and 'beta' not in tag and 'rc' not in tag:
        print(tag.removeprefix('rust-v'))
        break
")

CURRENT=$(grep -oP 'version = "\K[^"]+' "$PACKAGE_FILE")

if [ "$LATEST" = "$CURRENT" ]; then
  echo "Already at latest version: $CURRENT"
  exit 0
fi

echo "Updating codex: $CURRENT -> $LATEST"

declare -A HASHES
for target in x86_64-unknown-linux-gnu aarch64-unknown-linux-gnu; do
  url="https://github.com/openai/codex/releases/download/rust-v${LATEST}/codex-${target}.tar.gz"
  echo "  fetching $target..."
  raw=$(nix-prefetch-url "$url" 2>/dev/null)
  HASHES[$target]=$(nix hash convert --hash-algo sha256 --to sri "$raw")
done

sed -i "s|version = \"$CURRENT\"|version = \"$LATEST\"|" "$PACKAGE_FILE"

python3 <<EOF
import re
path = "$PACKAGE_FILE"
with open(path) as f:
    content = f.read()

replacements = {
    "x86_64-unknown-linux-gnu": "${HASHES[x86_64-unknown-linux-gnu]}",
    "aarch64-unknown-linux-gnu": "${HASHES[aarch64-unknown-linux-gnu]}",
}

for target, new_hash in replacements.items():
    pattern = rf'(target = "{re.escape(target)}";\s*\n\s*hash = ")[^"]+(";)'
    content = re.sub(pattern, rf'\g<1>{new_hash}\g<2>', content)

with open(path, "w") as f:
    f.write(content)
EOF

echo "Updated pkgs/codex/package.nix to $LATEST"
