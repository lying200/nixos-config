{ ... }:

{
  # GNOME 快捷键配置
  dconf.settings = {
    "org/gnome/settings-daemon/plugins/media-keys" = {
      # 禁用默认的终端快捷键
      terminal = [];

      # 自定义快捷键列表
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      ];
    };

    # 自定义快捷键：Ctrl+Alt+T 打开 Ghostty + Zellij
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "Open Terminal (Zellij)";
      command = "ghostty -e zellij";
      binding = "<Control><Alt>t";
    };
  };
}
