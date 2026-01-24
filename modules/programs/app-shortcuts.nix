{ lib, ... }:

{
  # 应用程序自定义快捷键
  programs.dconf.enable = true;

  programs.dconf.profiles.user.databases = [{
    settings = {
      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        ];
      };

      # Snipaste 截图快捷键: F1
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        name = "Snipaste Screenshot";
        command = "snipaste snip";
        binding = "F1";
      };

      # ulauncher 启动器快捷键: Alt+Space
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
        name = "ulauncher Toggle";
        command = "ulauncher-toggle";
        binding = "<Alt>space";
      };
    };
  }];
}
