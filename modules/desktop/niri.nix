{ config, lib, pkgs, ... }:

with lib;

{
  options.mySystem.desktop.niri = {
    enable = mkEnableOption "Niri compositor";
  };

  config = mkIf config.mySystem.desktop.niri.enable {
    # 启用 Niri
    programs.niri.enable = true;

    # XDG Desktop Portal 配置
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

    # X11 兼容性支持（通过 XWayland）
    programs.xwayland.enable = true;

    # Polkit 认证代理
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

    # Niri 需要的基础软件包（Noctalia 替代了 waybar/mako/swaylock/wlogout/swww/rofi/clipse/swayidle）
    environment.systemPackages = with pkgs; [
      # 截图工具
      grim              # Wayland 截图
      slurp             # Wayland 区域选择

      # 通知支持
      libnotify         # 通知 CLI

      # 剪贴板
      wl-clipboard      # Wayland 剪贴板工具

      # 网络和蓝牙
      networkmanagerapplet
      blueman

      # 媒体控制
      playerctl         # 媒体控制
      pavucontrol       # 音量控制面板

      # Polkit 认证
      polkit_gnome

      # 光标主题
      catppuccin-cursors.mochaDark

      # GTK/Qt 主题（Catppuccin Mocha）
      catppuccin-gtk
      papirus-icon-theme
      gnome-themes-extra
      adwaita-icon-theme

      # Qt 主题
      libsForQt5.qtstyleplugin-kvantum
      qt6Packages.qtstyleplugin-kvantum
      catppuccin-kvantum

      # Wayland 工具
      wtype             # Wayland 按键模拟
      xdg-utils         # xdg-open 等
      xwayland-satellite # Niri 的 XWayland 支持层
    ];

    # Niri 特有的环境变量
    environment.sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
      QT_QPA_PLATFORMTHEME = "kvantum";
      QT_STYLE_OVERRIDE = "kvantum";
      XDG_CURRENT_DESKTOP = "niri";
    };

    # 启用必要的服务
    services.gnome.gnome-keyring.enable = true;
    services.udisks2.enable = true;
    services.gvfs.enable = true;
    services.dbus.enable = true;
  };
}
