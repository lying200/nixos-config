{ config, lib, pkgs, ... }:

with lib;

{
  options.mySystem.services.tailscale = {
    enable = mkEnableOption "Tailscale VPN service";
  };

  config = mkIf config.mySystem.services.tailscale.enable {
    services.tailscale.enable = true;

    networking.firewall.checkReversePath = "loose";
    networking.firewall.trustedInterfaces = [ "tailscale0" ];
    networking.firewall.allowedUDPPorts = [ config.services.tailscale.port ];

    environment.systemPackages = [ pkgs.tailscale ];
  };
}
