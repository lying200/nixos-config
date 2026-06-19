{ config, pkgs, ... }:

let
  shell = config.myHome.desktop.wayland.shell;
  shellConfig = {
    dms = {
      binds = ./niri-config/binds-dms.kdl;
      startup = ./niri-config/empty.kdl;
      rules = ./niri-config/shell-rules-dms.kdl;
    };
    noctalia = {
      binds = ./niri-config/binds-noctalia.kdl;
      startup = ./niri-config/startup-noctalia.kdl;
      rules = ./niri-config/shell-rules-noctalia.kdl;
    };
    none = {
      binds = ./niri-config/empty.kdl;
      startup = ./niri-config/empty.kdl;
      rules = ./niri-config/empty.kdl;
    };
  }.${shell};
in
{
  xdg.configFile = {
    "niri/config.kdl".source = ./niri-config/config.kdl;
    "niri/binds-common.kdl".source = ./niri-config/binds-common.kdl;
    "niri/binds-shell.kdl".source = shellConfig.binds;
    "niri/colors.kdl".source = ./niri-config/colors.kdl;
    "niri/theme.kdl".source = ./niri-config/theme.kdl;
    "niri/output.kdl".source = ./niri-config/output.kdl;
    "niri/windowrule.kdl".source = ./niri-config/windowrule.kdl;
    "niri/animations.kdl".source = ./niri-config/animations.kdl;
    "niri/startup-common.kdl".source = ./niri-config/startup-common.kdl;
    "niri/startup-shell.kdl".source = shellConfig.startup;
    "niri/shell-rules.kdl".source = shellConfig.rules;

    "fastfetch/config.jsonc".source = ./fastfetch/config.jsonc;

    "Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=catppuccin-mocha-mauve
    '';

    "fcitx5/conf/classicui.conf".text = ''
      Theme=kwinblur-mellow-wechat
      ForceWaylandDPI=0
    '';

    "satty/config.toml".source = ./satty/config.toml;
  };

  home.sessionVariables = {
    GTK_IM_MODULE = "";
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
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
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
  };
}
