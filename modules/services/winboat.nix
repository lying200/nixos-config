{ config, lib, pkgs, username, ... }:

with lib;

{
  options.mySystem.services.winboat = {
    enable = mkEnableOption "WinBoat Windows app runtime";
  };

  config = mkIf config.mySystem.services.winboat.enable {
    assertions = [
      {
        assertion = config.mySystem.services.podman.enable;
        message = "WinBoat is configured for Podman; enable mySystem.services.podman.";
      }
    ];

    boot.kernelModules = [
      "ip_tables"
      "iptable_nat"
      "nf_tables"
    ];

    users.users.${username}.extraGroups = [ "kvm" ];

    environment.systemPackages = with pkgs; [
      freerdp
      winboat
    ];
  };
}
