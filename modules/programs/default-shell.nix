{ pkgs, username, ... }:

{
  # 系统级启用 Fish Shell 支持
  programs.fish.enable = true;

  # 设置用户默认 shell 为 Fish
  # 注意：这需要在 NixOS 配置中设置，Home Manager 不会修改 /etc/passwd
  users.users.${username}.shell = pkgs.fish;
}
