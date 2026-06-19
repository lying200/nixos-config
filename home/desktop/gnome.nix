{ ... }:

{
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "catppuccin-mocha-mauve-standard+default";
      icon-theme = "Papirus-Dark";
      cursor-theme = "catppuccin-mocha-dark-cursors";
      cursor-size = 24;
      font-name = "LXGW WenKai 11";
      document-font-name = "LXGW WenKai 12";
      monospace-font-name = "JetBrainsMono Nerd Font 11";
    };

    "org/gnome/shell" = {
      enabled-extensions = [
        "Vitals@CoreCoding.com"
        "blur-my-shell@aunetx"
        "caffeine@patapon.info"
        "dash-to-dock@micxgx.gmail.com"
        "tiling-assistant@leleat-on-github"
        "appindicatorsupport@rgcjonas.gmail.com"
        "clipboard-indicator@tudmotu.com"
        "kimpanel@kde.org"
      ];
    };

    "org/gnome/shell/extensions/vitals" = {
      hot-sensors = [
        "_processor_usage_"
        "_memory_usage_"
        "_temperature_processor_"
      ];
      position-in-panel = 2;
      show-temperature = true;
      show-voltage = false;
      show-fan = true;
      show-memory = true;
      show-processor = true;
      show-network = false;
      show-storage = false;
    };

    "org/gnome/shell/extensions/clipboard-indicator" = {
      history-size = 50;
      preview-size = 50;
      cache-only-favorites = false;
      display-mode = 0;
      enable-keybindings = true;
      notify-on-copy = false;
      move-item-first = true;
    };
  };
}
