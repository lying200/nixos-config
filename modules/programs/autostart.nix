{ pkgs, ... }:

{
  # 常用应用开机自启动配置
  # 使用 XDG autostart 规范，适用于 GNOME 等桌面环境

  environment.etc = {
    # JetBrains Toolbox
    "xdg/autostart/jetbrains-toolbox.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=JetBrains Toolbox
      Comment=JetBrains IDE Manager
      Exec=${pkgs.jetbrains-toolbox}/bin/jetbrains-toolbox --minimize
      Icon=jetbrains-toolbox
      Terminal=false
      Categories=Development;
      StartupNotify=false
      X-GNOME-Autostart-enabled=true
    '';

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
    # 延迟启动以确保 GNOME Shell 完全初始化
    "xdg/autostart/snipaste.desktop".text = ''
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
  };
}
