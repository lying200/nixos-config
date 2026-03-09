{ config, lib, pkgs, ... }:

with lib;

{
  options.mySystem.services.flatpak = {
    enable = mkEnableOption "Flatpak application manager";
  };

  config = mkIf config.mySystem.services.flatpak.enable {
    # 启用 Flatpak
    services.flatpak.enable = true;

    # 添加 Flathub 仓库（需要在系统初次启动后手动执行）
    # flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

    # XDG Desktop Portal（Flatpak 应用集成所需）
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
  };
}
