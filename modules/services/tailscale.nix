{ config, pkgs, ... }:

{
  services.tailscale.enable = true;
  networking.firewall.checkReversePath = "loose";
  networking.firewall.trustedInterfaces = [ "tailscale0" ];
  networking.firewall.allowedUDPPorts = [ config.services.tailscale.port ];
  
  environment.systemPackages = [ pkgs.tailscale ];
}
