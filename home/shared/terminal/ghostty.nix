{ pkgs, ... }:

{
  programs.ghostty = {
    enable = true;

    settings = {
      # 主题 - Ghostty 1.2.0+ 使用带空格的名称
      theme = "Catppuccin Mocha";

      # 字体配置
      font-family = "JetBrainsMono Nerd Font";
      font-size = 13;
      font-feature = [ "cv02" "cv14" "ss01" ];  # JetBrains Mono 连字特性

      # 窗口设置
      window-padding-x = 8;
      window-padding-y = 8;
      window-decoration = true;
      window-theme = "auto";

      # 光标
      cursor-style = "block";
      cursor-style-blink = true;

      # Shell 集成
      shell-integration = "fish";
      shell-integration-features = "cursor,sudo,title";

      # 终端类型 - 使用 xterm-256color 以保证 SSH 兼容性
      term = "xterm-256color";

      # 性能优化
      window-vsync = true;

      # 杂项
      clipboard-read = "allow";
      clipboard-write = "allow";
      confirm-close-surface = false;

      # 背景透明度 (可选)
      # background-opacity = 0.95;
      # background-blur-radius = 20;

      # 快捷键（使用 keybind 列表格式）
      keybind = [
        "ctrl+shift+c=copy_to_clipboard"
        "ctrl+shift+v=paste_from_clipboard"
        "ctrl+shift+t=new_tab"
        "ctrl+shift+w=close_surface"
        "ctrl+shift+n=new_window"
        "ctrl+shift+plus=increase_font_size:1"
        "ctrl+shift+minus=decrease_font_size:1"
        "ctrl+shift+zero=reset_font_size"
      ];
    };
  };
}
