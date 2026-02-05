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
        defaultNetwork.settings.dns_enabled = true;  # 允许 podman-compose 下的容器互相通信
      };
    };

    users.users.${username} = {
      extraGroups = [ "podman" ];
    };

    # 安装常用容器工具
    environment.systemPackages = with pkgs; [
      podman-compose  # docker-compose 的替代品
      podman-tui      # Podman 终端界面
    ];
  };
}
