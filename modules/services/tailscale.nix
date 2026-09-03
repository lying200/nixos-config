{
  config,
  lib,
  ...
}: {
  options.mySystem.services.tailscale = {
    enable = lib.mkEnableOption "Tailscale VPN service";
  };

  config = lib.mkIf config.mySystem.services.tailscale.enable {
    services.tailscale.enable = true;

    networking.firewall = {
      checkReversePath = "loose";
      trustedInterfaces = ["tailscale0"];
      allowedUDPPorts = [config.services.tailscale.port];
    };
  };
}
