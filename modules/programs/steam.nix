{ config, lib, pkgs, ... }:

with lib;

{
  options.mySystem.programs.steam = {
    enable = mkEnableOption "Steam gaming platform";
  };

  config = mkIf config.mySystem.programs.steam.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;

      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };

    environment.systemPackages = with pkgs; [
      mangohud
      gamemode
      gamescope
    ];

    programs.gamemode.enable = true;
  };
}
