{ config, pkgs, inputs, lib, ... }:

let
  useNoctalia = config.myHome.desktop.wayland.shell == "noctalia";
in
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  config = lib.mkIf useNoctalia {
    programs.noctalia-shell = {
      enable = true;

      settings = builtins.fromJSON (builtins.readFile ./noctalia-settings.json);

      plugins = {
        sources = [
          {
            enabled = true;
            name = "Noctalia Plugins";
            url = "https://github.com/noctalia-dev/noctalia-plugins";
          }
        ];
        states = {
          clipper = {
            enabled = true;
            sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
          };
        };
        version = 2;
      };
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
