{ config, lib, pkgs, ... }:

with lib;

{
  options.mySystem.services.tailscale = {
    enable = mkEnableOption "Tailscale VPN service";
  };

  config = mkIf config.mySystem.services.tailscale.enable {
    services.tailscale.enable = true;

    # 防火墙配置
    networking.firewall.checkReversePath = "loose";
    networking.firewall.trustedInterfaces = [ "tailscale0" ];
    networking.firewall.allowedUDPPorts = [ config.services.tailscale.port ];

    # 安装 CLI 工具
    environment.systemPackages = [ pkgs.tailscale ];
  };
}
