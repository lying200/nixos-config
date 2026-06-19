{ pkgs, ... }:

{
  # XDG autostart
  xdg.configFile = {

    # Snipaste 延迟启动
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

    # GNOME 窗口按钮
    "autostart/gnome-window-buttons.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=Restore GNOME Window Buttons
      Comment=Show window controls in GNOME
      Exec=desktop-window-buttons show
      Terminal=false
      StartupNotify=false
      X-GNOME-Autostart-enabled=true
      OnlyShowIn=GNOME;
    '';
  };
}
