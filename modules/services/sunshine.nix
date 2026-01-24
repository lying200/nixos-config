{ pkgs, config, ... }:

{
  # 1. 启用 Sunshine
  services.sunshine = {
    enable = true;
    autoStart = true;
    openFirewall = true;
    capSysAdmin = true;
  };

  # setsid 用于启动 Steam/Desktop 环境，xrandr 用于调整分辨率
  environment.systemPackages = with pkgs; [
    util-linux    # 包含 setsid
    xorg.xrandr   # 包含 xrandr
  ];

  # 强制加载 uinput 模块
  boot.kernelModules = [ "uinput" ];

  services.udev.extraRules = ''
    KERNEL=="uinput", SUBSYSTEM=="misc", OPTIONS+="static_node=uinput", MODE="0666"
  '';
}
