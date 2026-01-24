{ pkgs, ... }:

{
  # 常用应用开机自启动配置
  # 使用 XDG autostart 规范，适用于 GNOME 等桌面环境

  environment.etc = {
    # ulauncher 应用启动器
    "xdg/autostart/ulauncher.desktop".text = ''
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

    # Snipaste 截图工具
    "xdg/autostart/snipaste.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=Snipaste
      Comment=Screenshot Tool
      Exec=${pkgs.snipaste}/bin/snipaste
      Icon=snipaste
      Terminal=false
      Categories=Utility;Graphics;
      StartupNotify=false
      X-GNOME-Autostart-enabled=true
    '';

    # Variety 壁纸管理器
    "xdg/autostart/variety.desktop".text = ''
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

    # CopyQ 剪贴板管理器
    "xdg/autostart/copyq.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=CopyQ
      Comment=Clipboard Manager
      Exec=${pkgs.copyq}/bin/copyq
      Icon=copyq
      Terminal=false
      Categories=Utility;
      StartupNotify=false
      X-GNOME-Autostart-enabled=true
    '';
  };
}
