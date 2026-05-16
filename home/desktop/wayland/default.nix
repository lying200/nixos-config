{ lib, ... }:

{
  options.myHome.desktop.wayland.shell = lib.mkOption {
    type = lib.types.enum [ "dms" "noctalia" "none" ];
    default = "dms";
    description = "Wayland desktop shell to enable for the Home Manager desktop profile.";
  };

  imports = [
    ./lock.nix
    ./niri.nix
    ./noctalia.nix
    ./dms.nix
  ];
}
