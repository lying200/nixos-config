{ config, lib, pkgs, ... }:

with lib;

{
  options.mySystem.desktop.niri = {
    enable = mkEnableOption "Niri compositor";
  };

  config = mkIf config.mySystem.desktop.niri.enable {
    programs.niri.enable = true;

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gnome
        xdg-desktop-portal-gtk
      ];
      config.niri = {
        default = [ "gnome" "gtk" ];
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
      };
      xdgOpenUsePortal = true;
    };

    programs.xwayland.enable = true;

    systemd.user.services.polkit-gnome-authentication-agent-1 = {
      description = "Polkit GNOME authentication agent";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };

    # Noctalia 替代了 waybar/mako/swaylock/wlogout/swww/rofi/clipse/swayidle
    environment.systemPackages = with pkgs; [
      grim
      slurp
      libnotify
      wl-clipboard
      networkmanagerapplet
      blueman
      playerctl
      pavucontrol
      polkit_gnome
      catppuccin-cursors.mochaDark
      catppuccin-gtk
      papirus-icon-theme
      gnome-themes-extra
      adwaita-icon-theme
      libsForQt5.qtstyleplugin-kvantum
      qt6Packages.qtstyleplugin-kvantum
      catppuccin-kvantum
      wtype
      xdg-utils
      xwayland-satellite
    ];

    environment.sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
      QT_QPA_PLATFORMTHEME = "kvantum";
      QT_STYLE_OVERRIDE = "kvantum";
    };

    services.gnome.gnome-keyring.enable = true;
    services.udisks2.enable = true;
    services.gvfs.enable = true;
    services.dbus.enable = true;
  };
}
