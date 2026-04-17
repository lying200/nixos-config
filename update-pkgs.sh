#!/usr/bin/env bash
# 批量运行 pkgs/*/update.sh，更新所有自维护包
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

for script in "$SCRIPT_DIR"/pkgs/*/update.sh; do
    [ -x "$script" ] || continue
    pkg_name=$(basename "$(dirname "$script")")
    echo "📦 $pkg_name"
    "$script"
    echo ""
done
