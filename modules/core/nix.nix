{ ... }:

{
  # 允许闭源软件
  nixpkgs.config.allowUnfree = true;

  # 开启 Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

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
