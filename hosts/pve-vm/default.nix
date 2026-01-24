{ config, pkgs, ... }:

{
  imports = [
    # 硬件配置 (Host Specific)
    ./hardware.nix
    ./configuration.nix

    # 核心系统配置
    ../../modules/core/locale.nix
    ../../modules/core/fonts.nix
    ../../modules/core/base-packages.nix
    ../../modules/core/nix.nix

    # 硬件模块
    ../../modules/hardware/amd-gpu.nix

    # 桌面环境
    ../../modules/desktop/wayland.nix
    ../../modules/desktop/gnome.nix
    ../../modules/desktop/monitoring.nix

    # 服务
    ../../modules/services/tailscale.nix
    ../../modules/services/sunshine.nix

    # 程序
    ../../modules/programs/fcitx5.nix
    ../../modules/programs/qqmusic.nix
    ../../modules/programs/applications.nix
    ../../modules/programs/dev-tools.nix
    ../../modules/programs/app-shortcuts.nix
    ../../modules/programs/autostart.nix
    ../../modules/programs/git.nix
    ../../modules/programs/default-shell.nix
  ];
}
