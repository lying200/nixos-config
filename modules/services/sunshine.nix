{ config, lib, pkgs, ... }:

with lib;

{
  options.mySystem.services.sunshine = {
    enable = mkEnableOption "Sunshine game streaming server";
  };

  config = mkIf config.mySystem.services.sunshine.enable {
    # Sunshine 服务配置
    services.sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
    };

    # 防火墙配置
    networking.firewall = {
      allowedTCPPorts = [ 47984 47989 48010 ];
      allowedUDPPorts = [ 47998 47999 48000 48002 48010 ];
    };

    # 添加 udev 规则支持虚拟输入设备
    services.udev.packages = [ pkgs.sunshine ];
  };
}
