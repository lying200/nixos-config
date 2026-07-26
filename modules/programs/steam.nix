{ config, lib, pkgs, ... }:

{
  options.mySystem.programs.steam = {
    enable = lib.mkEnableOption "Steam gaming platform";
  };

  config = lib.mkIf config.mySystem.programs.steam.enable {
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
      gamescope
    ];

    programs.gamemode.enable = true;
  };
}
