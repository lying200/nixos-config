{ pkgs, lib, ... }:

{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  # 使用 Catppuccin Mocha 主题预设（与全局主题统一）
  home.activation.starshipPreset = lib.hm.dag.entryAfter ["writeBoundary"] ''
    ${pkgs.starship}/bin/starship preset catppuccin-mocha -o $HOME/.config/starship.toml

    # 替换 Apple 图标为 NixOS 雪花图标
    ${pkgs.gnused}/bin/sed -i 's/󰀵/󱄅/g' $HOME/.config/starship.toml
  '';
}
