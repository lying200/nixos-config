{ pkgs, ... }:

{
  programs.zellij = {
    enable = true;
    enableFishIntegration = true;

    settings = {
      # 主题
      theme = "catppuccin-mocha";

      # 默认布局
      default_layout = "compact";

      # UI 设置
      simplified_ui = true;
      pane_frames = false;  # 禁用边框，更简洁

      # 鼠标支持
      mouse_mode = true;
      scroll_buffer_size = 10000;

      # 复制模式
      copy_command = "wl-copy";  # Wayland 剪贴板
      copy_on_select = false;

      # 会话
      session_serialization = true;
      pane_viewport_serialization = true;
      scrollback_lines_to_serialize = 10000;

      # 自动布局
      auto_layout = true;

      # 镜像会话
      mirror_session = false;

      # 其他
      on_force_close = "quit";
      default_shell = "fish";

      # 禁用启动提示
      show_startup_tips = false;
    };
  };

  # Zellij 布局文件
  xdg.configFile."zellij/layouts/default.kdl".text = ''
    layout {
      default_tab_template {
        children
        pane size=1 borderless=true {
          plugin location="zellij:tab-bar"
        }
      }

      tab name="main" focus=true {
        pane
      }
    }
  '';

  # Zellij 主题配置
  xdg.configFile."zellij/themes/catppuccin-mocha.kdl".text = ''
    themes {
      catppuccin-mocha {
        fg "#CDD6F4"
        bg "#1E1E2E"
        black "#45475A"
        red "#F38BA8"
        green "#A6E3A1"
        yellow "#F9E2AF"
        blue "#89B4FA"
        magenta "#F5C2E7"
        cyan "#94E2D5"
        white "#BAC2DE"
        orange "#FAB387"
      }
    }
  '';

  xdg.configFile."zellij/themes/tokyo-night.kdl".text = ''
    themes {
      tokyo-night {
        fg "#a9b1d6"
        bg "#1a1b26"
        black "#32344a"
        red "#f7768e"
        green "#9ece6a"
        yellow "#e0af68"
        blue "#7aa2f7"
        magenta "#bb9af7"
        cyan "#7dcfff"
        white "#c0caf5"
        orange "#ff9e64"
      }
    }
  '';
}
