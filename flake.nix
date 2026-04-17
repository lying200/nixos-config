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
      inputs.noctalia-qs.follows = "noctalia-qs";
    };
    noctalia-qs = {
      url = "github:noctalia-dev/noctalia-qs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    devinit = {
      url = "github:lying200/devinit";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";

      # 用户配置（单一数据源）
      username = "echoyn";
      gitUserName = "lying200";
      gitUserEmail = "lying200@outlook.com";

      mkHost = hostname: { homeModule ? ./home/desktop }: nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit inputs username hostname gitUserName gitUserEmail;
        };

        modules = [
          ./hosts/${hostname}/default.nix

          { nixpkgs.overlays = [ (import ./overlays) ]; }

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.users.${username} = import homeModule;
            home-manager.extraSpecialArgs = {
              inherit inputs username hostname gitUserName gitUserEmail;
            };
          }
        ];
      };
    in {
      nixosConfigurations = {
        legion = mkHost "legion" {};
        wsl = mkHost "wsl" { homeModule = ./home/wsl; };
      };
    };
}
