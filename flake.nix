{
  description = "Echoyn's Modular NixOS Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

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
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";

      # 用户配置（单一数据源）
      username = "echoyn";
      gitUserName = "lying200";
      gitUserEmail = "lying200@outlook.com";

      mkHost = hostname: nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit inputs username hostname gitUserName gitUserEmail;
        };

        modules = [
          ./hosts/${hostname}/default.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.users.${username} = import ./home/shared;
            home-manager.extraSpecialArgs = {
              inherit inputs username hostname gitUserName gitUserEmail;
            };
          }
        ];
      };
    in {
      nixosConfigurations = {
        desktop = mkHost "desktop";
        legion = mkHost "legion";
      };
    };
}
