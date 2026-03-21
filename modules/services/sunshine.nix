{ config, lib, pkgs, ... }:

with lib;

{
  options.mySystem.services.sunshine = {
    enable = mkEnableOption "Sunshine game streaming server";
  };

  config = mkIf config.mySystem.services.sunshine.enable {
    services.sunshine = {
      enable = true;
      autoStart = true;
      openFirewall = true;
      capSysAdmin = true;
    };

    # setsid 用于启动 Steam/Desktop 环境，xrandr 用于调整分辨率
    environment.systemPackages = with pkgs; [
      util-linux
      xorg.xrandr
    ];

    # 键鼠输入必需
    boot.kernelModules = [ "uinput" ];

    # 允许 Sunshine 访问虚拟输入设备
    services.udev.extraRules = ''
      KERNEL=="uinput", SUBSYSTEM=="misc", OPTIONS+="static_node=uinput", MODE="0666"
    '';
  };
}
