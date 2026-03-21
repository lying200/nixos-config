{ config, pkgs, username, ... }:

{
  # Home Manager 基础配置
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "24.11";

  # 导入各模块
  imports = [
    ./terminal
    ./wayland
    ./programs/git.nix
    ./programs/neovim.nix
    ./programs/direnv.nix
    ./programs/zed.nix
    ./programs/applications.nix
    ./programs/autostart.nix
    ./programs/keybindings.nix
  ];

  # CLI 工具（用户级）
  home.packages = with pkgs; [
    eza         # 现代化的 ls
    bat         # 更好的 cat
    fzf         # 模糊搜索
    zoxide      # 智能 cd
    delta       # Git diff 工具
  ];

  # 会话级环境变量（对所有程序可见，包括 Zellij）
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";

    # JetBrains 系软件使用 Wayland
    _JAVA_OPTIONS = "-Dawt.toolkit.name=WLToolkit";
  };

  # XDG 标准用户目录
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    pictures = "${config.home.homeDirectory}/Pictures";
    documents = "${config.home.homeDirectory}/Documents";
    download = "${config.home.homeDirectory}/Downloads";
    music = "${config.home.homeDirectory}/Music";
    videos = "${config.home.homeDirectory}/Videos";
    desktop = "${config.home.homeDirectory}/Desktop";
    extraConfig = {
      WALLPAPERS = "${config.home.homeDirectory}/Pictures/Wallpapers";
    };
  };

  # 添加 ~/.local/bin 到 PATH
  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  # 让 Home Manager 管理自己
  programs.home-manager.enable = true;
}
