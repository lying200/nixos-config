{ config, lib, pkgs, ... }:

with lib;

{
  options.mySystem.desktop.monitoring = {
    enable = mkEnableOption "Desktop system monitoring tools and GNOME extensions";
  };

  config = mkIf config.mySystem.desktop.monitoring.enable {
    hardware.sensor.iio.enable = true;

    environment.systemPackages = with pkgs; [
      lm_sensors
      htop
      gnome-tweaks
      gnomeExtensions.vitals
      gnomeExtensions.blur-my-shell
      gnomeExtensions.caffeine
      gnomeExtensions.dash-to-dock
      gnomeExtensions.tiling-assistant
      gnomeExtensions.appindicator
      gnomeExtensions.clipboard-indicator
    ];
  };
}
