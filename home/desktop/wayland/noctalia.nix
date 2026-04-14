{ pkgs, inputs, ... }:

{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia-shell = {
    enable = true;

    settings = builtins.fromJSON (builtins.readFile ./noctalia-settings.json);
  };

  # Noctalia 运行时依赖
  home.packages = with pkgs; [
    brightnessctl
    imagemagick
    python3
    git
    cliphist
    wlsunset
  ];
}
