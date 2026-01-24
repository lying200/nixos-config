{ ... }:

{
  # 允许闭源软件
  nixpkgs.config.allowUnfree = true;

  # 开启 Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # GitHub Access Token 配置（避免 API 速率限制）
  # 使用方法：
  # 1. 创建 GitHub token: https://github.com/settings/tokens (classic, 只需 public_repo 权限)
  # 2. 添加到 ~/.config/nix/nix.conf:
  #    access-tokens = github.com=ghp_xxxxxxxxxxxx
  nix.settings.accept-flake-config = true;

  # 自动垃圾回收
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # 自动优化 store（硬链接相同文件）
  nix.settings.auto-optimise-store = true;

  # SSH 服务
  services.openssh.enable = true;
}
