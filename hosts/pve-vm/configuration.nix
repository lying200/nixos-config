{ ... }:

{
  # Bootloader (每台机器可能不同，有的双系统，有的单系统)
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # 主机名
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # 用户定义
  users.users.echoyn = {
    isNormalUser = true;
    description = "echoyn";
    extraGroups = [ "networkmanager" "wheel" "video" "input" "uinput" ];
    packages = [ ];
  };

  system.stateVersion = "24.11";
}
