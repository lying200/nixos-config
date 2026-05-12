{ config, pkgs, username, inputs, ... }:

let
  npmGlobalPrefix = "${config.home.homeDirectory}/.local/share/npm";
in
{
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "25.11";

  imports = [
    ./terminal
    ./programs/git.nix
    ./programs/neovim
    ./programs/direnv.nix
  ];

  home.packages = with pkgs; [
    eza
    bat
    fzf
    zoxide
    delta
    inputs.devinit.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    NPM_CONFIG_PREFIX = npmGlobalPrefix;
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    setSessionVariables = false;
    pictures = "${config.home.homeDirectory}/Pictures";
    documents = "${config.home.homeDirectory}/Documents";
    download = "${config.home.homeDirectory}/Downloads";
    music = "${config.home.homeDirectory}/Music";
    videos = "${config.home.homeDirectory}/Videos";
    desktop = "${config.home.homeDirectory}/Desktop";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.local/share/npm/bin"
  ];

  home.file.".npmrc".text = ''
    prefix=${npmGlobalPrefix}
  '';

  xdg.dataFile."npm/.keep".text = "";

  programs.home-manager.enable = true;
}
