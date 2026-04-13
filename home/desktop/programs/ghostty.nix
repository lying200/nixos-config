{ pkgs, ... }:

{
  programs.ghostty = {
    enable = true;

    settings = {
      theme = "Catppuccin Mocha";

      # 字体
      font-family = "JetBrainsMono Nerd Font";
      font-size = 13;
      font-feature = [ "cv02" "cv14" "ss01" ];
      adjust-cell-height = "10%";

      # 窗口
      window-padding-x = 10;
      window-padding-y = 8;
      window-decoration = false;
      window-theme = "ghostty";
      window-vsync = true;

      # 光标
      cursor-style = "block";
      cursor-style-blink = false;

      # Shell
      shell-integration = "fish";
      shell-integration-features = "cursor,sudo,title";
      term = "xterm-256color";

      # 剪贴板
      clipboard-read = "allow";
      clipboard-write = "allow";
      copy-on-select = "clipboard";
      confirm-close-surface = false;

      # 滚动
      mouse-scroll-multiplier = 0.5;

      # 渲染
      bold-is-bright = false;

      # 背景透明
      background-opacity = 0.95;
      background-blur = true;
    };
  };
}
