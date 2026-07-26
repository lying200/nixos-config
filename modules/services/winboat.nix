{ config, lib, pkgs, username, ... }:

{
  options.mySystem.services.winboat = {
    enable = lib.mkEnableOption "WinBoat Windows app runtime";
  };

  config = lib.mkIf config.mySystem.services.winboat.enable {
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
