{ config, pkgs, ... }:

{
  xdg.configFile = {
    "niri/config.kdl".source = ./niri-config/config.kdl;
    "niri/binds.kdl".source = ./niri-config/binds.kdl;
    "niri/colors.kdl".source = ./niri-config/colors.kdl;
    "niri/theme.kdl".source = ./niri-config/theme.kdl;
    "niri/output.kdl".source = ./niri-config/output.kdl;
    "niri/windowrule.kdl".source = ./niri-config/windowrule.kdl;
    "niri/animations.kdl".source = ./niri-config/animations.kdl;
    "niri/startup.kdl".source = ./niri-config/startup.kdl;

    "fastfetch/config.jsonc".source = ./fastfetch/config.jsonc;

    "Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=catppuccin-mocha-mauve
    '';

    "fcitx5/conf/classicui.conf".text = ''
      Theme=kwinblur-mellow-wechat
      ForceWaylandDPI=0
    '';

    "satty/config.toml".text = ''
      [general]
      fullscreen = false
      early-exit = true
      initial-tool = "arrow"
      copy-command = "wl-copy"
      annotation-size-factor = 0.6
      save-after-copy = false
      default-hide-toolbars = false
      primary-highlighter = "block"
      disable-notifications = true
      # 右键自动复制并退出
      actions-on-right-click = ["save-to-clipboard", "exit"]
      # Enter 键复制到剪贴板
      actions-on-enter = ["save-to-clipboard"]
      # Esc 退出
      actions-on-escape = ["exit"]

      [color-palette]
      palette = [
        "#ff0000",  # 红色 - 醒目标注
        "#ffff00",  # 黄色 - 高亮重点
        "#00ff00",  # 绿色 - 正确/通过
        "#ff9900",  # 橙色 - 警告
        "#0099ff",  # 蓝色 - 信息提示
        "#ffffff"   # 白色 - 通用
      ]

      [font]
      family = "Maple Mono SC NF"
      style = "Bold"
    '';
  };

  home.sessionVariables = {
    GTK_IM_MODULE = "";
  };

  programs.fish = {
    loginShellInit = ''
      if test "$XDG_SESSION_TYPE" = "wayland"
        and test "$XDG_CURRENT_DESKTOP" = "niri"
        set -gx _JAVA_AWT_WM_NONREPARENTING 1
      end
    '';
  };

  gtk = {
    enable = true;
    cursorTheme = {
      name = "catppuccin-mocha-dark-cursors";
      size = 24;
    };
    theme = {
      name = "catppuccin-mocha-mauve-standard+default";
    };
    iconTheme = {
      name = "Papirus-Dark";
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
      gtk-decoration-layout = "";
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
      gtk-decoration-layout = "";
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style.name = "kvantum";
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "catppuccin-mocha-mauve-standard+default";
      icon-theme = "Papirus-Dark";
      cursor-theme = "catppuccin-mocha-dark-cursors";
      cursor-size = 24;
    };
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "";
    };
  };
}
