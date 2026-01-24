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

  # 自动启用 GNOME 扩展
  programs.dconf.enable = true;

  # 为所有用户设置默认扩展
  programs.dconf.profiles.user.databases = [{
    settings = {
      "org/gnome/shell" = {
        enabled-extensions = [
          "Vitals@CoreCoding.com"
          "appindicatorsupport@rgcjonas.gmail.com"
          "clipboard-indicator@tudmotu.com"
          "kimpanel@kde.org"  # Fcitx5 输入法面板
        ];
      };

      # Vitals 扩展配置
      "org/gnome/shell/extensions/vitals" = {
        hot-sensors = [ "_processor_usage_" "_memory_usage_" "_temperature_processor_" ];
        position-in-panel = lib.gvariant.mkInt32 2;  # 0=left, 1=center, 2=right
        show-temperature = true;
        show-voltage = false;
        show-fan = true;
        show-memory = true;
        show-processor = true;
        show-network = false;
        show-storage = false;
      };

      # Clipboard Indicator 扩展配置
      "org/gnome/shell/extensions/clipboard-indicator" = {
        history-size = lib.gvariant.mkInt32 50;  # 保存 50 条历史
        preview-size = lib.gvariant.mkInt32 50;  # 预览长度
        cache-only-favorites = false;
        display-mode = lib.gvariant.mkInt32 0;   # 0=图标模式
        enable-keybindings = true;
        notify-on-copy = false;  # 复制时不显示通知
        move-item-first = true;  # 新复制的项目排在最前
      };
    };
  }];
}
