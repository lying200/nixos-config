#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE_FILE="$SCRIPT_DIR/package.nix"

prefetch_sri() {
  local url="$1"
  local raw_hash

  raw_hash=$(nix-prefetch-url "$url")
  nix hash convert --hash-algo sha256 --to sri "$raw_hash"
}

latest_release_url="https://github.com/openai/codex/releases/latest"
if ! latest_url=$(curl -fsSIL -o /dev/null -w '%{url_effective}' "$latest_release_url"); then
  echo "Failed to fetch latest Codex release: $latest_release_url" >&2
  exit 1
fi

LATEST="${latest_url##*/}"
LATEST="${LATEST#rust-v}"

if [[ -z "$LATEST" || "$LATEST" == "latest" ]]; then
  echo "Failed to determine latest Codex version from: $latest_url" >&2
  exit 1
fi

CURRENT=$(sed -n 's/^[[:space:]]*version = "\([^"]*\)";[[:space:]]*$/\1/p' "$PACKAGE_FILE")

if [[ -z "$CURRENT" || "$CURRENT" == *$'\n'* ]]; then
  echo "Failed to determine exactly one current Codex version from: $PACKAGE_FILE" >&2
  exit 1
fi

if [[ "$LATEST" == "$CURRENT" ]]; then
  echo "Already at latest version: $CURRENT"
  exit 0
fi

echo "Updating Codex: $CURRENT -> $LATEST"

declare -A CODEX_HASHES
declare -A CODE_MODE_HOST_HASHES
X86_TARGET="x86_64-unknown-linux-musl"
ARM_TARGET="aarch64-unknown-linux-musl"

for target in "$X86_TARGET" "$ARM_TARGET"; do
  codex_url="https://github.com/openai/codex/releases/download/rust-v${LATEST}/codex-${target}.tar.gz"
  code_mode_host_url="https://github.com/openai/codex/releases/download/rust-v${LATEST}/codex-code-mode-host-${target}.tar.gz"

  echo "  fetching Codex for $target..."
  if ! hash=$(prefetch_sri "$codex_url"); then
    echo "Failed to fetch Codex asset: $codex_url" >&2
    exit 1
  fi
  CODEX_HASHES["$target"]="$hash"

  echo "  fetching Code Mode host for $target..."
  if ! hash=$(prefetch_sri "$code_mode_host_url"); then
    echo "Failed to fetch Code Mode host asset: $code_mode_host_url" >&2
    exit 1
  fi
  CODE_MODE_HOST_HASHES["$target"]="$hash"
done

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
  -v x86_codex_hash="${CODEX_HASHES[$X86_TARGET]}" \
  -v x86_host_hash="${CODE_MODE_HOST_HASHES[$X86_TARGET]}" \
  -v arm_codex_hash="${CODEX_HASHES[$ARM_TARGET]}" \
  -v arm_host_hash="${CODE_MODE_HOST_HASHES[$ARM_TARGET]}" \
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

      if ($0 ~ /^[[:space:]]*target = "x86_64-unknown-linux-musl";[[:space:]]*$/) {
        if (platform != "") fail("nested or unterminated platform block")
        platform = "x86"
        target_count[platform]++
      } else if ($0 ~ /^[[:space:]]*target = "aarch64-unknown-linux-musl";[[:space:]]*$/) {
        if (platform != "") fail("nested or unterminated platform block")
        platform = "arm"
        target_count[platform]++
      }

      if (platform != "" && $0 ~ /^[[:space:]]*codexHash = "[^"]*";[[:space:]]*$/) {
        replacement = platform == "x86" ? x86_codex_hash : arm_codex_hash
        sub(/codexHash = "[^"]*";/, "codexHash = \"" replacement "\";")
        codex_hash_count[platform]++
      }

      if (platform != "" && $0 ~ /^[[:space:]]*codeModeHostHash = "[^"]*";[[:space:]]*$/) {
        replacement = platform == "x86" ? x86_host_hash : arm_host_hash
        sub(/codeModeHostHash = "[^"]*";/, "codeModeHostHash = \"" replacement "\";")
        host_hash_count[platform]++
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
      if (target_count["x86"] != 1 || codex_hash_count["x86"] != 1 || host_hash_count["x86"] != 1) {
        fail("expected exactly one x86_64 target and one update for each of its hashes")
      }
      if (target_count["arm"] != 1 || codex_hash_count["arm"] != 1 || host_hash_count["arm"] != 1) {
        fail("expected exactly one aarch64 target and one update for each of its hashes")
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

echo "Updated $PACKAGE_FILE to Codex $LATEST"
