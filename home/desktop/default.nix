{
  config,
  desktopProfile,
  lib,
  ...
}: {
  imports =
    [
      ../common
      ./window-buttons.nix

      ./programs/applications.nix
      ./programs/chrome.nix
      ./programs/zed.nix
      ./programs/windterm.nix
      ./programs/ghostty.nix
      ./programs/fish-desktop.nix
    ]
    ++ lib.optionals desktopProfile.gnome [
      ./gnome.nix
      ./programs/autostart.nix
      ./programs/keybindings.nix
    ]
    ++ lib.optionals desktopProfile.niri [
      ./wayland
    ];

  config =
    {
      gtk.gtk4.theme = null;

      xdg.userDirs.extraConfig = {
        WALLPAPERS = "${config.home.homeDirectory}/Pictures/Wallpapers";
      };
    }
    // lib.optionalAttrs desktopProfile.niri {
      myHome.desktop.wayland.shell = desktopProfile.shell;
    };
}
