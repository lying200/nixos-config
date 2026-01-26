#!/usr/bin/env bash
# NixOS 配置更新脚本

set -e

# 获取脚本所在目录的绝对路径
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# 自动检测当前主机名
HOSTNAME=$(hostname)

echo "🔄 更新 flake inputs..."
nix flake update

echo ""
echo "🔨 测试构建 (主机: $HOSTNAME)..."
sudo nixos-rebuild test --flake "$SCRIPT_DIR#$HOSTNAME"

echo ""
read -p "✅ 测试通过！是否切换到新配置？[y/N] " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🚀 切换到新配置..."
    sudo nixos-rebuild switch --flake "$SCRIPT_DIR#$HOSTNAME"
    echo ""
    echo "✅ 更新完成并已切换！"
else
    echo "⏸️  已跳过切换，配置保持不变"
    echo "如需切换，运行: sudo nixos-rebuild switch --flake $SCRIPT_DIR#$HOSTNAME"
fi
