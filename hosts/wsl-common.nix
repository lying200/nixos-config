{
  inputs,
  lib,
  username,
  ...
}: {
  imports = [
    inputs.nixos-wsl.nixosModules.wsl
    inputs.paseo.nixosModules.paseo
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

  # Windows Paseo connects to the WSL daemon through localhost forwarding.
  services.paseo = {
    enable = true;
    user = username;
    group = "users";
    listenAddress = "127.0.0.1";
    port = 6768; # Avoid the Windows desktop daemon's default port (6767).
    openFirewall = false;
    relay = {
      enable = true;
      mode = "remote";
      host = "paseo.fly-start.com";
      port = 443;
      useTls = true;
    };
    inheritUserEnvironment = false;
    environment.HOME = "/home/${username}";
    environment.PASEO_RELAY_ENABLED = "true";
  };

  # systemd does not load Fish or Home Manager session initialization.
  systemd.services.paseo.environment.PATH = lib.mkForce (lib.concatStringsSep ":" [
    "/home/${username}/.local/bin"
    "/home/${username}/.kimi-code/bin"
    "/home/${username}/.local/share/npm/bin"
    "/home/${username}/.nix-profile/bin"
    "/home/${username}/.local/state/nix/profile/bin"
    "/etc/profiles/per-user/${username}/bin"
    "/run/current-system/sw/bin"
    "/run/wrappers/bin"
    "/nix/var/nix/profiles/default/bin"
  ]);

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
