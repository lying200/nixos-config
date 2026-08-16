#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE_FILE="$SCRIPT_DIR/package.nix"
LATEST_URL="https://code.kimi.com/kimi-code/latest"

if ! LATEST=$(curl -fsSL "$LATEST_URL"); then
  echo "Failed to fetch the latest Kimi Code version: $LATEST_URL" >&2
  exit 1
fi
LATEST=$(printf '%s' "$LATEST" | tr -d '[:space:]')

if [[ ! "$LATEST" =~ ^[0-9]+\.[0-9]+\.[0-9]+([.-][0-9A-Za-z.-]+)?$ ]]; then
  echo "Invalid Kimi Code version returned by $LATEST_URL: $LATEST" >&2
  exit 1
fi

CURRENT=$(sed -n 's/^[[:space:]]*version = "\([^"]*\)";[[:space:]]*$/\1/p' "$PACKAGE_FILE")

if [[ -z "$CURRENT" || "$CURRENT" == *$'\n'* ]]; then
  echo "Failed to determine exactly one current Kimi Code version from: $PACKAGE_FILE" >&2
  exit 1
fi

if [[ "$LATEST" == "$CURRENT" ]]; then
  echo "Already at latest version: $CURRENT"
  exit 0
fi

echo "Updating Kimi Code: $CURRENT -> $LATEST"

RELEASE_BASE="https://github.com/MoonshotAI/kimi-code/releases/download/%40moonshot-ai%2Fkimi-code%40${LATEST}"
MANIFEST_URL="$RELEASE_BASE/manifest.json"

if ! MANIFEST=$(curl -fsSL "$MANIFEST_URL"); then
  echo "Failed to fetch the Kimi Code release manifest: $MANIFEST_URL" >&2
  exit 1
fi

manifest_hash() {
  local platform="$1"
  local expected_filename="$2"
  local filename
  local checksum

  filename=$(jq -er --arg platform "$platform" '.platforms[$platform].filename' <<<"$MANIFEST")
  checksum=$(jq -er --arg platform "$platform" '.platforms[$platform].checksum' <<<"$MANIFEST")

  if [[ "$filename" != "$expected_filename" ]]; then
    echo "Unexpected asset for $platform: $filename (expected $expected_filename)" >&2
    return 1
  fi
  if [[ ! "$checksum" =~ ^[0-9a-f]{64}$ ]]; then
    echo "Invalid checksum for $platform: $checksum" >&2
    return 1
  fi

  nix hash convert --hash-algo sha256 --to sri "$checksum"
}

X86_HASH=$(manifest_hash "linux-x64" "kimi-code-linux-x64.zip")
ARM_HASH=$(manifest_hash "linux-arm64" "kimi-code-linux-arm64.zip")

TMP_PACKAGE_FILE=$(mktemp --tmpdir="$(dirname "$PACKAGE_FILE")" ".package.nix.XXXXXX")
UPDATED_PACKAGE_FILE="${TMP_PACKAGE_FILE}.updated"

cleanup() {
  rm -f "$TMP_PACKAGE_FILE" "$UPDATED_PACKAGE_FILE"
}
trap cleanup EXIT

cp --preserve=mode "$PACKAGE_FILE" "$TMP_PACKAGE_FILE"

if ! awk \
  -v current="$CURRENT" \
  -v latest="$LATEST" \
  -v x86_hash="$X86_HASH" \
  -v arm_hash="$ARM_HASH" \
  '
    function fail(message) {
      print "Update validation failed: " message > "/dev/stderr"
      invalid = 1
    }

    {
      if ($0 ~ /^[[:space:]]*version = "[^"]*";[[:space:]]*$/) {
        version_count++
        if (index($0, "version = \"" current "\";") == 0) {
          fail("the version line does not contain the expected current version")
        } else {
          sub(/version = "[^"]*";/, "version = \"" latest "\";")
          version_updates++
        }
      }

      if ($0 ~ /^[[:space:]]*asset = "linux-x64";[[:space:]]*$/) {
        if (platform != "") fail("nested or unterminated platform block")
        platform = "x86"
        asset_count[platform]++
      } else if ($0 ~ /^[[:space:]]*asset = "linux-arm64";[[:space:]]*$/) {
        if (platform != "") fail("nested or unterminated platform block")
        platform = "arm"
        asset_count[platform]++
      }

      if (platform != "" && $0 ~ /^[[:space:]]*hash = "[^"]*";[[:space:]]*$/) {
        replacement = platform == "x86" ? x86_hash : arm_hash
        sub(/hash = "[^"]*";/, "hash = \"" replacement "\";")
        hash_count[platform]++
      }

      print

      if (platform != "" && $0 ~ /^[[:space:]]*};[[:space:]]*$/) {
        platform = ""
      }
    }

    END {
      if (version_count != 1 || version_updates != 1) {
        fail("expected exactly one version update")
      }
      if (asset_count["x86"] != 1 || hash_count["x86"] != 1) {
        fail("expected exactly one x86_64 asset and hash update")
      }
      if (asset_count["arm"] != 1 || hash_count["arm"] != 1) {
        fail("expected exactly one aarch64 asset and hash update")
      }
      if (platform != "") {
        fail("unterminated platform block")
      }
      if (invalid) exit 1
    }
  ' \
  "$TMP_PACKAGE_FILE" >"$UPDATED_PACKAGE_FILE"; then
  echo "Failed to update $PACKAGE_FILE safely" >&2
  exit 1
fi

chmod --reference="$PACKAGE_FILE" "$UPDATED_PACKAGE_FILE"

if ! nix-instantiate --parse "$UPDATED_PACKAGE_FILE" >/dev/null; then
  echo "Updated package does not parse as Nix; leaving $PACKAGE_FILE unchanged" >&2
  exit 1
fi

mv "$UPDATED_PACKAGE_FILE" "$PACKAGE_FILE"
rm -f "$TMP_PACKAGE_FILE"
trap - EXIT

echo "Updated $PACKAGE_FILE to Kimi Code $LATEST"
