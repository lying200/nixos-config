{
  inputs,
  userSettings,
  hosts,
}: let
  inherit (inputs.nixpkgs) lib;
  inherit (userSettings) username gitUserName gitUserEmail;
  desktopProfileLib = import ./desktop-profile.nix {inherit lib;};

  mkHost = hostname: host: let
    rawDesktopProfile = host.desktopProfile or null;
    desktopProfile =
      if rawDesktopProfile == null
      then null
      else desktopProfileLib.validate rawDesktopProfile;
  in
    lib.nixosSystem {
      system = host.system or "x86_64-linux";

      specialArgs = {
        inherit inputs hostname desktopProfile username gitUserName gitUserEmail;
      };

      modules = [
        host.hostModule

        inputs.home-manager.nixosModules.home-manager
        ({lib, ...}:
          lib.mkMerge [
            {
              networking.hostName = hostname;

              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                users.${username} = import host.homeModule;
                extraSpecialArgs = {
                  inherit inputs hostname desktopProfile username gitUserName gitUserEmail;
                };
              };
            }
            (lib.mkIf (desktopProfile != null) {
              mySystem = desktopProfileLib.toSystemConfig desktopProfile;
            })
          ])
      ];
    };
in
  lib.mapAttrs mkHost hosts
