{ username, ... }:

{
  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];

    # GitHub Access Token 配置（避免 API 速率限制）
    # 使用方法：
    # 1. 创建 GitHub token: https://github.com/settings/tokens (classic, 只需 public_repo 权限)
    # 2. 添加到 ~/.config/nix/nix.conf:
    #    access-tokens = github.com=ghp_xxxxxxxxxxxx
    accept-flake-config = true;

    # 防止 GC 清理 direnv/devenv 缓存
    keep-outputs = true;
    keep-derivations = true;

    auto-optimise-store = true;

    # 信任用户（允许 devenv 自动管理 binary caches）
    trusted-users = [ "root" username ];

    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  services.openssh.enable = true;
}
