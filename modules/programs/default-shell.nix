{ pkgs, username, ... }:

{
  programs.fish.enable = true;

  # 注意：这需要在 NixOS 配置中设置，Home Manager 不会修改 /etc/passwd
  users.users.${username}.shell = pkgs.fish;
}
