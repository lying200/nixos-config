{ ... }:

{
  dconf.settings = {
    "org/gnome/desktop/wm/keybindings" = {
      activate-window-menu = ["<Ctrl><Alt><Shift>w"];
      close = ["<Super>q" "<Alt>F4"];
    };

    "org/gnome/shell/keybindings" = {
      toggle-application-view = ["<Super>d"];
    };

    "org/gnome/shell/extensions/clipboard-indicator" = {
      toggle-menu = ["<Super>y"];
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      terminal = [];
      screensaver = ["<Super>l" "<Super><Alt>l"];

      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
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
      binding = "<Super>t";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
      name = "File Manager";
      command = "nautilus";
      binding = "<Super>e";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
      name = "Browser";
      command = "google-chrome-stable";
      binding = "<Super>b";
    };
  };
}
