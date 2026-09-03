{
  config,
  lib,
  pkgs,
  ...
}: {
  options.mySystem.desktop.niri = {
    enable = lib.mkEnableOption "Niri compositor";
  };

  config = lib.mkIf config.mySystem.desktop.niri.enable {
    programs.niri.enable = true;

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gnome
        xdg-desktop-portal-gtk
      ];
      config.niri = {
        default = ["gnome" "gtk"];
        "org.freedesktop.impl.portal.FileChooser" = ["gtk"];
      };
      xdgOpenUsePortal = true;
    };

    programs.xwayland.enable = true;

    systemd.user.services.polkit-gnome-authentication-agent-1 = {
      description = "Polkit GNOME authentication agent";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };

    # Wayland 桌面工具
    environment.systemPackages = with pkgs; [
      grim
      slurp
      libnotify
      wl-clipboard
      networkmanagerapplet
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
      swaylock
      xwayland-satellite
    ];

    security.pam.services.swaylock = {};

    # Kvantum 主题由 home-manager 的 qt.platformTheme/style 设置（home/desktop/wayland/niri.nix）
    environment.sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
    };

    services = {
      gnome.gnome-keyring.enable = true;
      udisks2.enable = true;
      gvfs.enable = true;
      dbus.enable = true;
    };
  };
}
