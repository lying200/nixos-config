{ username, ... }:

{
  # Bootloader (每台机器可能不同，有的双系统，有的单系统)
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # 主机名
  networking.hostName = "legion";
  networking.networkmanager.enable = true;

  # hosts 配置
  networking.hosts = {
    "192.168.3.160" = [ "dev.com" ];
  };

  # 用户定义
  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = [ "networkmanager" "wheel" "video" "input" "uinput" ];
    packages = [ ];
  };

  system.stateVersion = "24.11";
}
