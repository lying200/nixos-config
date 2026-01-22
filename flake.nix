{
  description = "Echoyn's Modular NixOS Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    # 雾凇拼音源
    rime-ice.url = "github:iDvel/rime-ice";
    rime-ice.flake = false;
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
    in {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          inherit system;
          
          # 传递 inputs 给所有模块
          specialArgs = { inherit inputs; };

          modules = [
            ./hosts/pve-vm/default.nix
          ];
        };
      };
    };
}
