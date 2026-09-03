{
  description = "Echoyn's Modular NixOS Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

    rime-ice.url = "github:iDvel/rime-ice";
    rime-ice.flake = false;

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    devinit = {
      url = "github:lying200/devinit";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    paseo = {
      url = "github:getpaseo/paseo";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }: let
    system = "x86_64-linux";

    userSettings = {
      username = "echoyn";
      gitUserName = "lying200";
      gitUserEmail = "lying200@outlook.com";
    };

    desktopProfiles.hybrid = {
      gnome = true;
      niri = true;
      wayland = true;
      monitoring = true;
      shell = "dms";
      inputMethod = "fcitx5";
    };

    hosts = {
      legion = {
        inherit system;
        hostModule = ./hosts/legion;
        homeModule = ./home/desktop;
        desktopProfile = desktopProfiles.hybrid;
      };
      legion-wsl = {
        inherit system;
        hostModule = ./hosts/wsl-common.nix;
        homeModule = ./home/wsl;
      };
      wsl = {
        inherit system;
        hostModule = ./hosts/wsl-common.nix;
        homeModule = ./home/wsl;
      };
    };

    nixosConfigurations = import ./lib/mk-hosts.nix {
      inherit inputs userSettings hosts;
    };

    pkgs = nixpkgs.legacyPackages.${system};
  in {
    inherit nixosConfigurations;

    formatter.${system} = pkgs.writeShellScriptBin "format-nix" ''
      if [[ $# -eq 0 ]]; then
        set -- .
      fi
      exec ${pkgs.alejandra}/bin/alejandra "$@"
    '';

    checks.${system} = import ./tests/flake-checks.nix {
      inherit hosts nixosConfigurations pkgs userSettings;
      source = self;
    };
  };
}
