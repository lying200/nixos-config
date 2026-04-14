{ ... }:

{
  dconf.settings = {
    "org/gnome/desktop/wm/keybindings" = {
      activate-window-menu = ["<Ctrl><Alt><Shift>w"];
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      terminal = [];

      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "Snipaste Screenshot";
      command = "snipaste snip";
      binding = "F1";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      name = "Open Terminal (Zellij)";
      command = "ghostty -e zellij";
      binding = "<Control><Alt>t";
    };
  };
}
