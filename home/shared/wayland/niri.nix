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
      Theme=mellow-graphite-dark
      ForceWaylandDPI=0
      Font="Noto Sans CJK SC 11"
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
