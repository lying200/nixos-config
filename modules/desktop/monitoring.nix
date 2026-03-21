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
      gnomeExtensions.appindicator
      gnomeExtensions.clipboard-indicator
    ];

    # 注意：这里的配置仅作为默认值，用户手动启用/禁用扩展后会被覆盖
    # 如需强制启用扩展，需要使用 home-manager 或通过脚本定期重置
    services.desktopManager.gnome.extraGSettingsOverrides = ''
      [org.gnome.shell]
      enabled-extensions=['Vitals@CoreCoding.com', 'appindicatorsupport@rgcjonas.gmail.com', 'clipboard-indicator@tudmotu.com', 'kimpanel@kde.org']

      [org.gnome.shell.extensions.vitals]
      hot-sensors=['_processor_usage_', '_memory_usage_', '_temperature_processor_']
      position-in-panel=2
      show-temperature=true
      show-voltage=false
      show-fan=true
      show-memory=true
      show-processor=true
      show-network=false
      show-storage=false

      [org.gnome.shell.extensions.clipboard-indicator]
      history-size=50
      preview-size=50
      cache-only-favorites=false
      display-mode=0
      enable-keybindings=true
      notify-on-copy=false
      move-item-first=true
    '';
  };
}
