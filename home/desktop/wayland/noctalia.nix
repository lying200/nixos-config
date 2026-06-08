{ config, pkgs, inputs, lib, ... }:

let
  useNoctalia = config.myHome.desktop.wayland.shell == "noctalia";
in
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  config = lib.mkIf useNoctalia {
    programs.noctalia = {
      enable = true;

      settings = ./noctalia-settings.toml;
    };

    home.packages = with pkgs; [
      brightnessctl
      imagemagick
      python3
      git
      cliphist
      wlsunset
    ];
  };
}
