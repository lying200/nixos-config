{ config, ... }:

{
  imports = [
    ../common

    ./gnome.nix
    ./window-buttons.nix

    ./programs/applications.nix
    ./programs/zed.nix
    ./programs/windterm.nix
    ./programs/cc-switch.nix
    ./programs/autostart.nix
    ./programs/keybindings.nix
    ./programs/ghostty.nix
    ./programs/fish-desktop.nix

    ./wayland
  ];

  gtk.gtk4.theme = null;

  xdg.userDirs.extraConfig = {
    WALLPAPERS = "${config.home.homeDirectory}/Pictures/Wallpapers";
  };
}
