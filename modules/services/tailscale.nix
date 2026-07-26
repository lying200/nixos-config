{ config, lib, ... }:

{
  options.mySystem.services.tailscale = {
    enable = lib.mkEnableOption "Tailscale VPN service";
  };

  config = lib.mkIf config.mySystem.services.tailscale.enable {
    services.tailscale.enable = true;

    networking.firewall.checkReversePath = "loose";
    networking.firewall.trustedInterfaces = [ "tailscale0" ];
    networking.firewall.allowedUDPPorts = [ config.services.tailscale.port ];
  };
}
