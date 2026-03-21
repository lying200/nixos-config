{ config, lib, pkgs, ... }:

with lib;

{
  options.mySystem.desktop.gnome = {
    enable = mkEnableOption "GNOME desktop environment";
  };

  config = mkIf config.mySystem.desktop.gnome.enable {
    # 桌面环境
    services.xserver.enable = true;
    services.displayManager.gdm.wayland = true;
    services.desktopManager.gnome.enable = true;
    services.displayManager.gdm.enable = true;

    # GNOME Mutter 缩放设置（全局）
    services.desktopManager.gnome.extraGSettingsOverrides = lib.mkAfter ''
      [org.gnome.mutter]
      experimental-features=['scale-monitor-framebuffer', 'xwayland-native-scaling']
    '';
  };
}
