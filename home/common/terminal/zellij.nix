{ config, lib, pkgs, ... }:

let
  cfg = config.myHome.programs.zellij;
in
{
  options.myHome.programs.zellij.clipboardCommand = lib.mkOption {
    type = lib.types.str;
    default = "wl-copy";
    description = "Command Zellij uses to copy text to the system clipboard.";
  };

  config = {
    programs.zellij = {
      enable = true;
      enableFishIntegration = false;
    };

    xdg.configFile."zellij/config.kdl".source = pkgs.replaceVars ./zellij/config.kdl {
      clipboardCommand = cfg.clipboardCommand;
    };
    xdg.configFile."zellij/layouts/default.kdl".source = ./zellij/layouts/default.kdl;
    xdg.configFile."zellij/themes/catppuccin-mocha.kdl".source = ./zellij/themes/catppuccin-mocha.kdl;
  };
}
