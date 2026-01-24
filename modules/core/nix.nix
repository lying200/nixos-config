{ ... }:

{
  # 允许闭源软件
  nixpkgs.config.allowUnfree = true;

  # 开启 Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # SSH 服务
  services.openssh.enable = true;
}
