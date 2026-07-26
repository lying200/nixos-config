{ config, lib, pkgs, ... }:

{
  options.mySystem.desktop.monitoring = {
    enable = lib.mkEnableOption "Desktop system monitoring tools and GNOME extensions";
  };

  config = lib.mkIf config.mySystem.desktop.monitoring.enable {
    hardware.sensor.iio.enable = true;

    # GNOME 扩展包在 home/desktop/gnome.nix，与 enabled-extensions 列表同处
    environment.systemPackages = with pkgs; [
      lm_sensors
      htop
    ];
  };
}
