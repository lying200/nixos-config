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
    ../../modules/hardware/nvidia-gpu.nix
    ../../modules/hardware/intel-gpu.nix

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
    ../../modules/programs/dev-tools.nix
    ../../modules/programs/autostart.nix
    ../../modules/programs/default-shell.nix
  ];

  # 启用功能模块
  mySystem = {
    # 硬件配置
    hardware = {
      amdgpu.enable = true;      # AMD 显卡
      # nvidia.enable = false;   # NVIDIA 显卡（按需启用）
      # intelgpu.enable = false; # Intel 核显（按需启用）
    };

    # 桌面环境
    desktop = {
      gnome.enable = true;
      wayland.enable = true;
      monitoring.enable = true;
    };

    # 系统服务
    services = {
      tailscale.enable = true;
      sunshine.enable = true;
    };
  };
}
