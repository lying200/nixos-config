{ config, lib, pkgs, username, ... }:

with lib;

{
  options.mySystem.services.podman = {
    enable = mkEnableOption "Podman container runtime";
  };

  config = mkIf config.mySystem.services.podman.enable {
    virtualisation = {
      containers.enable = true;
      podman = {
        enable = true;
        dockerCompat = true;
        # 允许 podman-compose 下的容器互相通信
        defaultNetwork.settings.dns_enabled = true;
      };
    };

    users.users.${username} = {
      extraGroups = [ "podman" ];
    };

    environment.systemPackages = with pkgs; [
      podman-compose
      podman-tui
    ];
  };
}
