{
  inputs,
  username,
  ...
}: {
  imports = [
    inputs.nixos-wsl.nixosModules.wsl
    ../modules
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

  services.openssh.enable = true;

  networking.hosts = {
    "100.64.0.3" = ["infra.dev.internal"];
    "100.64.0.4" = ["ops.dev.internal"];
  };

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = ["wheel"];
  };

  mySystem.services = {
    tailscale.enable = true;
    podman.enable = true;
  };

  system.stateVersion = "25.11";
}
