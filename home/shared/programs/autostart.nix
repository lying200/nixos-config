{ pkgs, ... }:

{
  # 用户应用开机自启动配置
  # 使用 XDG autostart 规范，通过 OnlyShowIn/NotShowIn 区分桌面环境

  xdg.configFile = {

    # Snipaste 截图工具（延迟启动避免缩放问题）
    "autostart/snipaste.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=Snipaste
      Comment=Screenshot Tool
      Exec=sh -c 'sleep 5 && ${pkgs.snipaste}/bin/snipaste'
      Icon=snipaste
      Terminal=false
      Categories=Utility;Graphics;
      StartupNotify=false
      X-GNOME-Autostart-enabled=true
      X-GNOME-Autostart-Delay=3
      OnlyShowIn=GNOME;
    '';

    # Variety 壁纸管理器（仅 GNOME 下自启动，niri 下使用 swww）
    "autostart/variety.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=Variety
      Comment=Wallpaper Changer
      Exec=${pkgs.variety}/bin/variety
      Icon=variety
      Terminal=false
      Categories=Utility;
      StartupNotify=false
      OnlyShowIn=GNOME;
    '';
  };
}
