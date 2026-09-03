{
  config,
  lib,
  pkgs,
  ...
}: {
  options.mySystem.services.printing = {
    enable = lib.mkEnableOption "CUPS printing support";
  };

  config = lib.mkIf config.mySystem.services.printing.enable {
    services.printing.enable = true;

    environment.systemPackages = with pkgs; [
      cups-pk-helper
    ];
  };
}
