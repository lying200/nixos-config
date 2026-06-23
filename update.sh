#!/usr/bin/env bash
# NixOS 配置更新脚本

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOSTNAME=$(hostname)
SUDO_KEEPALIVE_PID=""

cleanup_sudo_keepalive() {
    if [[ -n "$SUDO_KEEPALIVE_PID" ]]; then
        kill "$SUDO_KEEPALIVE_PID" 2>/dev/null || true
    fi
}

keep_sudo_alive() {
    sudo -v

    while true; do
        sleep 60
        sudo -n -v || exit
    done &
    SUDO_KEEPALIVE_PID=$!
}

trap cleanup_sudo_keepalive EXIT

cd "$SCRIPT_DIR"
echo ""
echo "🔐 获取 sudo 权限..."
keep_sudo_alive

echo ""
echo "📦 更新自维护包..."
"$SCRIPT_DIR/update-pkgs.sh"

echo ""
echo "🔄 更新 flake inputs..."
nix flake update

echo ""
echo "🚀 切换到新配置 (主机: $HOSTNAME)..."
sudo nixos-rebuild switch --flake "$SCRIPT_DIR#$HOSTNAME"

echo ""
echo "✅ 更新完成！"
