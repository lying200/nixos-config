{ ... }:

{
  programs.zellij = {
    enable = true;
    enableFishIntegration = true;
  };

  xdg.configFile."zellij/config.kdl".source = ./zellij/config.kdl;
  xdg.configFile."zellij/layouts/default.kdl".source = ./zellij/layouts/default.kdl;
  xdg.configFile."zellij/themes/catppuccin-mocha.kdl".source = ./zellij/themes/catppuccin-mocha.kdl;
}
