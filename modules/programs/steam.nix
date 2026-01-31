{ config, lib, pkgs, ... }:

with lib;

{
  options.mySystem.programs.steam = {
    enable = mkEnableOption "Steam gaming platform";
  };

  config = mkIf config.mySystem.programs.steam.enable {
    # 启用 Steam
    programs.steam = {
      enable = true;

      # 启用远程游戏
      remotePlay.openFirewall = true;

      # 启用专用服务器端口
      dedicatedServer.openFirewall = true;

      # 启用局域网游戏发现
      localNetworkGameTransfers.openFirewall = true;

      # 额外兼容性工具（Proton-GE 等）
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };

    # 游戏相关的额外软件包
    environment.systemPackages = with pkgs; [
      mangohud          # 游戏性能监控 HUD
      gamemode          # 游戏性能优化
      gamescope         # 微型 Wayland 合成器，用于游戏
    ];

    # 启用 GameMode（自动优化游戏性能）
    programs.gamemode.enable = true;
  };
}
