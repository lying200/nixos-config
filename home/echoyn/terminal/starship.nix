{ pkgs, lib, ... }:

{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  # 使用 Tokyo Night 官方预设并自定义
  # https://starship.rs/presets/tokyo-night
  home.activation.starshipPreset = lib.hm.dag.entryAfter ["writeBoundary"] ''
    # 应用 Tokyo Night 预设
    ${pkgs.starship}/bin/starship preset tokyo-night -o $HOME/.config/starship.toml

    # 替换 Apple 图标为 NixOS 雪花图标
    ${pkgs.gnused}/bin/sed -i 's///g' $HOME/.config/starship.toml
  '';
}
