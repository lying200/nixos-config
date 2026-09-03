{
  config,
  lib,
  ...
}: {
  options.mySystem.desktop.gnome = {
    enable = lib.mkEnableOption "GNOME desktop environment";
  };

  config = lib.mkIf config.mySystem.desktop.gnome.enable {
    services = {
      xserver.enable = true;
      desktopManager.gnome = {
        enable = true;
        extraGSettingsOverrides = lib.mkAfter ''
          [org.gnome.mutter]
          experimental-features=['scale-monitor-framebuffer', 'xwayland-native-scaling']
        '';
      };
      displayManager.gdm.enable = true;
    };
  };
}
