{ pkgs, ... }:

{
  # 用户应用开机自启动配置
  # 使用 XDG autostart 规范

  xdg.configFile = {

    # ulauncher 应用启动器（隐藏窗口启动）
    "autostart/ulauncher.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=Ulauncher
      Comment=Application Launcher
      Exec=${pkgs.ulauncher}/bin/ulauncher --hide-window
      Icon=ulauncher
      Terminal=false
      Categories=Utility;
      StartupNotify=false
      X-GNOME-Autostart-enabled=true
    '';

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
    '';

    # Variety 壁纸管理器
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
      X-GNOME-Autostart-enabled=true
    '';
  };
}
