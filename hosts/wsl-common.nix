{ inputs, username, hostname, ... }:

{
  imports = [
    inputs.nixos-wsl.nixosModules.wsl

    ../modules/core/locale.nix
    ../modules/core/base-packages.nix
    ../modules/core/nix.nix
    ../modules/core/compatibility.nix

    ../modules/services/tailscale.nix
    ../modules/services/podman.nix

    ../modules/programs/dev-tools.nix
    ../modules/programs/default-shell.nix
    ../modules/programs/nix-ld.nix
  ];

  wsl = {
    enable = true;
    defaultUser = username;

    # Windows 互操作
    interop = {
      register = true;
      includePath = true;
    };
  };

  networking.hostName = hostname;

  services.openssh.enable = true;

  networking.hosts = {
    "100.64.0.3" = [ "infra.dev.internal" ];
    "100.64.0.4" = [ "ops.dev.internal" ];
  };

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  mySystem.services = {
    tailscale.enable = true;
    podman.enable = true;
  };

  system.stateVersion = "25.11";
}
