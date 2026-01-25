{ ... }:

{
  # GNOME 快捷键配置（Home Manager）
  dconf.settings = {
    # 窗口管理快捷键
    "org/gnome/desktop/wm/keybindings" = {
      # 修改 activate window menu 快捷键为 Ctrl+Alt+Shift+W
      activate-window-menu = ["<Ctrl><Alt><Shift>w"];
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      # 禁用默认的终端快捷键
      terminal = [];

      # 自定义快捷键列表
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
      ];
    };

    # Custom 0: Snipaste 截图快捷键
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "Snipaste Screenshot";
      command = "snipaste snip";
      binding = "F1";
    };

    # Custom 1: ulauncher 启动器快捷键
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      name = "ulauncher Toggle";
      command = "ulauncher-toggle";
      binding = "<Alt>space";
    };

    # Custom 2: Ghostty + Zellij 终端快捷键
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
      name = "Open Terminal (Zellij)";
      command = "ghostty -e zellij";
      binding = "<Control><Alt>t";
    };
  };
}
