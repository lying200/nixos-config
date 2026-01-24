{ pkgs, lib, ... }:

{
  # 安装 GNOME 扩展和监控工具
  environment.systemPackages = with pkgs; [
    lm_sensors       # 传感器检测工具 (sensors 命令)
    htop             # 系统资源监控
    gnome-tweaks     # GNOME 调整工具

    # GNOME 扩展
    gnomeExtensions.vitals           # 系统监控扩展 (CPU/内存/温度)
    gnomeExtensions.appindicator     # 系统托盘支持 (显示 Toolbox 等应用图标)
    gnomeExtensions.clipboard-indicator  # 剪贴板历史管理器（原生 GNOME 扩展）
  ];

  # GNOME 扩展配置（通过 dconf/gsettings）
  # 注意：这里的配置仅作为默认值，用户手动启用/禁用扩展后会被覆盖
  # 如需强制启用扩展，需要使用 home-manager 或通过脚本定期重置
  services.desktopManager.gnome.extraGSettingsOverrides = ''
    [org.gnome.shell]
    enabled-extensions=['Vitals@CoreCoding.com', 'appindicatorsupport@rgcjonas.gmail.com', 'clipboard-indicator@tudmotu.com', 'kimpanel@kde.org']

    [org.gnome.shell.extensions.vitals]
    hot-sensors=['_processor_usage_', '_memory_usage_', '_temperature_processor_']
    position-in-panel=2
    show-temperature=true
    show-voltage=false
    show-fan=true
    show-memory=true
    show-processor=true
    show-network=false
    show-storage=false

    [org.gnome.shell.extensions.clipboard-indicator]
    history-size=50
    preview-size=50
    cache-only-favorites=false
    display-mode=0
    enable-keybindings=true
    notify-on-copy=false
    move-item-first=true
  '';
}
