{ config, pkgs, ... }:

{
  imports = [
    ./configuration.nix

    ../../modules/core/locale.nix
    ../../modules/core/base-packages.nix
    ../../modules/core/nix.nix
    ../../modules/core/compatibility.nix

    ../../modules/services/tailscale.nix
    ../../modules/services/podman.nix

    ../../modules/programs/dev-tools.nix
    ../../modules/programs/default-shell.nix
    ../../modules/programs/nix-ld.nix
  ];

  mySystem = {
    services = {
      tailscale.enable = true;
      podman.enable = true;
    };
  };
}
