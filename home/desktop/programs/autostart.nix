{ pkgs, ... }:

{
  # 使用 XDG autostart 规范，通过 OnlyShowIn/NotShowIn 区分桌面环境
  xdg.configFile = {

    # 延迟启动避免缩放问题
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
