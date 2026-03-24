{ config, pkgs, username, ... }:

{
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "25.11";

  imports = [
    ./terminal
    ./wayland
    ./programs/git.nix
    ./programs/neovim.nix
    ./programs/direnv.nix
    ./programs/zed.nix
    ./programs/applications.nix
    ./programs/windterm.nix
    ./programs/cc-switch.nix
    ./programs/autostart.nix
    ./programs/keybindings.nix
  ];

  home.packages = with pkgs; [
    eza
    bat
    fzf
    zoxide
    delta
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";

    # JetBrains 系软件使用 Wayland
    _JAVA_OPTIONS = "-Dawt.toolkit.name=WLToolkit";
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    pictures = "${config.home.homeDirectory}/Pictures";
    documents = "${config.home.homeDirectory}/Documents";
    download = "${config.home.homeDirectory}/Downloads";
    music = "${config.home.homeDirectory}/Music";
    videos = "${config.home.homeDirectory}/Videos";
    desktop = "${config.home.homeDirectory}/Desktop";
    extraConfig = {
      WALLPAPERS = "${config.home.homeDirectory}/Pictures/Wallpapers";
    };
  };

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  programs.home-manager.enable = true;
}
