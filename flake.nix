{
  description = "Echoyn's Modular NixOS Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home Manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # 雾凇拼音源
    rime-ice.url = "github:iDvel/rime-ice";
    rime-ice.flake = false;
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";

      # 用户配置（单一数据源）
      username = "echoyn";                      # 系统用户名和家目录名
      gitUserName = "lying200";                 # Git 提交作者名
      gitUserEmail = "lying200@outlook.com";    # Git 提交作者邮箱
    in {
      nixosConfigurations = {
        desktop = nixpkgs.lib.nixosSystem {
          inherit system;

          # 传递 inputs 和用户配置给所有模块
          specialArgs = {
            inherit inputs username gitUserName gitUserEmail;
          };

          modules = [
            ./hosts/desktop/default.nix

            # Home Manager 集成
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${username} = import ./home/shared;
              home-manager.extraSpecialArgs = {
                inherit inputs username gitUserName gitUserEmail;
              };
            }
          ];
        };
      };
    };
}
