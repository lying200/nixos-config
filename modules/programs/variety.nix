{ pkgs, ... }:

{
  # Variety 壁纸管理器配置
  # 已在 applications.nix 中安装

  # 系统级自动启动配置
  environment.etc."xdg/autostart/variety.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Variety
    Comment=Wallpaper Changer
    Exec=${pkgs.variety}/bin/variety
    Icon=variety
    Terminal=false
    Categories=Utility;
    StartupNotify=false
    X-GNOME-Autostart-enabled=true
  '';
}
