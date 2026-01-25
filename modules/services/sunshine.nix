{ config, lib, pkgs, ... }:

with lib;

{
  options.mySystem.services.sunshine = {
    enable = mkEnableOption "Sunshine game streaming server";
  };

  config = mkIf config.mySystem.services.sunshine.enable {
    # 1. Sunshine 服务配置
    services.sunshine = {
      enable = true;
      autoStart = true;
      openFirewall = true;    # 自动配置防火墙
      capSysAdmin = true;
    };

    # 2. setsid 用于启动 Steam/Desktop 环境，xrandr 用于调整分辨率
    environment.systemPackages = with pkgs; [
      util-linux    # 包含 setsid
      xorg.xrandr   # 包含 xrandr
    ];

    # 3. 强制加载 uinput 模块（键鼠输入必需）
    boot.kernelModules = [ "uinput" ];

    # 4. udev 规则（允许 Sunshine 访问虚拟输入设备）
    services.udev.extraRules = ''
      KERNEL=="uinput", SUBSYSTEM=="misc", OPTIONS+="static_node=uinput", MODE="0666"
    '';
  };
}
