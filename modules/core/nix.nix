{
  pkgs,
  username,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  programs.nh = {
    enable = true;
    flake = "/home/${username}/nixos-config";
  };

  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };

  environment.systemPackages = with pkgs; [
    comma
    nvd
  ];

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];

    # 接受 flake 声明的 nixConfig（如第三方 substituters）
    accept-flake-config = true;

    # 防止 GC 清理 direnv/devenv 缓存
    keep-outputs = true;
    keep-derivations = true;

    auto-optimise-store = true;

    # 信任用户（允许 devenv 自动管理 binary caches）
    trusted-users = ["root" username];

    substituters = [
      "https://mirrors.ustc.edu.cn/nix-channels/store?priority=30"
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
}
