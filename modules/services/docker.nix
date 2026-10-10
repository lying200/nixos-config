{
  config,
  lib,
  pkgs,
  username,
  ...
}: {
  options.mySystem.services.docker = {
    enable = lib.mkEnableOption "Docker container runtime";
  };

  config = lib.mkIf config.mySystem.services.docker.enable {
    virtualisation.docker.enable = true;

    users.users.${username} = {
      extraGroups = ["docker"];
    };

    environment.systemPackages = with pkgs; [
      docker-compose
    ];
  };
}
