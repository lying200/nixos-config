{ config, pkgs, username, ... }:

{
  # Home Manager 基础配置
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "24.11";

  # 导入各模块
  imports = [
    ./terminal
    ./programs/keybindings.nix
  ];

  # 基础包
  home.packages = with pkgs; [
    # CLI 工具
    eza         # 现代化的 ls
    bat         # 更好的 cat
    fzf         # 模糊搜索
    fd          # 更好的 find
    ripgrep     # 更好的 grep
    zoxide      # 智能 cd
    delta       # Git diff 工具
  ];

  # 让 Home Manager 管理自己
  programs.home-manager.enable = true;
}
