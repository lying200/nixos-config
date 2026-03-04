{ config, lib, pkgs, ... }:

with lib;

{
  options.mySystem.desktop.wayland = {
    enable = mkEnableOption "Wayland environment support";
  };

  config = mkIf config.mySystem.desktop.wayland.enable {
    # Pipewire 音频服务（Wayland 通用）
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;

    # Polkit 权限管理
    security.polkit.enable = true;

    # Wayland 环境变量（应用原生 Wayland 支持）
    # 使用 mkDefault 以便 niri.nix 等更具体的模块可以覆盖
    environment.sessionVariables = {
      # Electron/Chromium 应用
      NIXOS_OZONE_WL = lib.mkDefault "1";

      # Qt 应用
      QT_QPA_PLATFORM = lib.mkDefault "wayland";

      # GTK 应用
      GDK_BACKEND = lib.mkDefault "wayland,x11";

      # SDL 游戏
      SDL_VIDEODRIVER = lib.mkDefault "wayland";

      # XDG
      XDG_SESSION_TYPE = "wayland";
    };
  };
}
