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
      systemd.enable = true;
    };
  };
}
