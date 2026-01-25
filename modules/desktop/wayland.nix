{ config, lib, pkgs, ... }:

with lib;

{
  options.mySystem.desktop.wayland = {
    enable = mkEnableOption "Wayland environment support";
  };

  config = mkIf config.mySystem.desktop.wayland.enable {
    # XDG Desktop Portal 配置（文件选择对话框等）
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
      config = {
        common = {
          default = [ "gnome" ];
        };
      };
    };

    # Pipewire 音频服务
    services.pipewire.enable = true;

    # Polkit 权限管理
    security.polkit.enable = true;

    # Wayland 环境变量（应用原生 Wayland 支持）
    environment.sessionVariables = {
      # Electron/Chromium 应用
      NIXOS_OZONE_WL = "1";

      # Qt 应用
      QT_QPA_PLATFORM = "wayland";

      # GTK 应用
      GDK_BACKEND = "wayland";

      # SDL 游戏
      SDL_VIDEODRIVER = "wayland";
    };
  };
}
