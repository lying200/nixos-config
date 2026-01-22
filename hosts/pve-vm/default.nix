{ config, pkgs, ... }:

{
  imports = [
    # 1. 硬件相关 (Host Specific)
    ./hardware-configuration.nix
    ./amd-gpu.nix

    # 2. 通用功能 (Common Modules)
    ../../modules/system/base.nix
    ../../modules/system/tailscale.nix
    ../../modules/system/fcitx5.nix
    ../../modules/system/sunshine.nix
    ../../modules/system/apps.nix
  ];

  
  # Bootloader (每台机器可能不同，有的双系统，有的单系统)
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # 主机名
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # 桌面环境
  services.xserver.enable = true;
  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm.enable = true;
  
  # 音频
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # 用户定义
  users.users.echoyn = {
    isNormalUser = true;
    description = "echoyn";
    extraGroups = [ "networkmanager" "wheel" "video" "input" "uinput" ];
    packages = with pkgs; [];
  };

  system.stateVersion = "24.11";

  programs.git = {
    enable = true;
    
    config = {
      # 1. 身份信息
      user = {
        name = "lying200";
        email = "lying200@outlook.com";
      };

      # 2. 默认分支名
      init = {
        defaultBranch = "main";
      };

      core = {
        editor = "vim";       # 默认编辑器
        autocrlf = "input";   # 处理换行符
      };
    };
  };

  boot.kernelParams = [ 
    "video=DP-1:2560x1440@60D" 
  ];
}
