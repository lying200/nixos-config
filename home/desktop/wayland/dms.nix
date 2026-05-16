{ config, inputs, lib, ... }:

let
  useDms = config.myHome.desktop.wayland.shell == "dms";
in
{
  imports = [
    inputs.dms.homeModules.dank-material-shell
  ];

  config = lib.mkIf useDms {
    programs.dank-material-shell = {
      enable = true;

      # niri starts DMS from its startup include, so leave the user systemd
      # service off to avoid launching a second shell instance.
      systemd.enable = false;
    };
  };
}
