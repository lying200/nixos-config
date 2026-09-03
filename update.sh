#!/usr/bin/env bash
# Safely update flake inputs, show the generation diff, then switch.

set -euo pipefail

CONFIG_DIR="${NIXOS_CONFIG_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"
TARGET_HOST="${NIXOS_HOST:-$(hostname)}"
ASSUME_YES=false
LOCK_BACKUP=""
KEEP_LOCK=false

usage() {
    printf 'Usage: %s [--yes] [--host HOST]\n' "${0##*/}"
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --yes|-y)
            ASSUME_YES=true
            shift
            ;;
        --host)
            [[ $# -ge 2 ]] || { usage >&2; exit 2; }
            TARGET_HOST="$2"
            shift 2
            ;;
        --help|-h)
            usage
            exit 0
            ;;
        *)
            printf 'Unknown argument: %s\n' "$1" >&2
            usage >&2
            exit 2
            ;;
    esac
done

cd "$CONFIG_DIR"

if [[ ! -f flake.nix || ! -f flake.lock ]]; then
    printf 'Not a locked flake directory: %s\n' "$CONFIG_DIR" >&2
    exit 1
fi

if ! git diff --quiet -- flake.lock || ! git diff --cached --quiet -- flake.lock; then
    printf 'flake.lock already has changes; commit or stash them first.\n' >&2
    exit 1
fi

if ! nix eval --raw ".#nixosConfigurations.${TARGET_HOST}.config.networking.hostName" >/dev/null; then
    printf 'Unknown host: %s\n' "$TARGET_HOST" >&2
    exit 1
fi

LOCK_BACKUP="$(mktemp)"
cp flake.lock "$LOCK_BACKUP"

cleanup() {
    if [[ "$KEEP_LOCK" != true && -n "$LOCK_BACKUP" && -f "$LOCK_BACKUP" ]]; then
        cp "$LOCK_BACKUP" flake.lock
        printf '\nRestored flake.lock because the update did not complete.\n' >&2
    fi
    [[ -z "$LOCK_BACKUP" ]] || rm -f "$LOCK_BACKUP"
}
trap cleanup EXIT

printf '\n🔄 Updating flake inputs...\n'
nix flake update

printf '\n🔎 Evaluating every host and repository check...\n'
nix flake check

printf '\n🏗️  Building host: %s...\n' "$TARGET_HOST"
nixos-rebuild build --flake ".#${TARGET_HOST}"

if [[ -e /run/current-system && -x result/sw/bin/nvd ]]; then
    printf '\n📋 Generation diff:\n'
    result/sw/bin/nvd diff /run/current-system result
fi

if [[ "$ASSUME_YES" != true ]]; then
    printf '\nSwitch to this generation? [y/N] '
    read -r reply
    if [[ ! "$reply" =~ ^[Yy]$ ]]; then
        printf 'Cancelled.\n'
        exit 0
    fi
fi

printf '\n🚀 Switching host: %s...\n' "$TARGET_HOST"
sudo nixos-rebuild switch --flake ".#${TARGET_HOST}"

KEEP_LOCK=true
printf '\n✅ Update complete.\n'
