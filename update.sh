#!/usr/bin/env bash
# NixOS 配置更新脚本

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOSTNAME=$(hostname)

cd "$SCRIPT_DIR"

echo ""
echo "🔐 获取 sudo 权限..."
sudo -v

echo ""
echo "📦 更新自维护包..."
"$SCRIPT_DIR/update-pkgs.sh"

echo ""
echo "🔄 更新 flake inputs..."
sudo nix flake update

echo ""
echo "🚀 切换到新配置 (主机: $HOSTNAME)..."
sudo nixos-rebuild switch --flake "$SCRIPT_DIR#$HOSTNAME"

echo ""
echo "✅ 更新完成！"
