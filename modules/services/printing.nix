{ config, lib, pkgs, ... }:

with lib;

{
  options.mySystem.services.printing = {
    enable = mkEnableOption "CUPS printing support";
  };

  config = mkIf config.mySystem.services.printing.enable {
    services.printing.enable = true;

    environment.systemPackages = with pkgs; [
      cups-pk-helper
    ];
  };
}
