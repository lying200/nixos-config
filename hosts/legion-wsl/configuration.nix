{ inputs, username, ... }:

{
  imports = [
    inputs.nixos-wsl.nixosModules.wsl
  ];

  wsl = {
    enable = true;
    defaultUser = username;

    interop = {
      register = true;
      includePath = true;
    };
  };

  networking.hostName = "legion-wsl";

  networking.hosts = {
    "100.64.0.3" = [ "infra.dev.internal" ];
    "100.64.0.4" = [ "ops.dev.internal" ];
  };

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  system.stateVersion = "25.11";
}
