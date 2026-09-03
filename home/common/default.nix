{
  config,
  pkgs,
  username,
  inputs,
  ...
}: let
  npmGlobalPrefix = "${config.home.homeDirectory}/.local/share/npm";
in {
  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.11";

    packages = with pkgs; [
      eza
      bat
      fzf
      zoxide
      delta
      bubblewrap
      socat
      inputs.devinit.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/.kimi-code/bin"
      "${npmGlobalPrefix}/bin"
    ];

    file.".npmrc".text = ''
      prefix=${npmGlobalPrefix}
    '';
  };

  imports = [
    ./terminal
    ./programs/git.nix
    ./programs/ssh.nix
    ./programs/neovim
    ./programs/direnv.nix
    ./programs/nix-index.nix
  ];

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

  xdg.dataFile."npm/.keep".text = "";

  programs.home-manager.enable = true;
}
