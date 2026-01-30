{ username, ... }:

{
  # Bootloader (每台机器可能不同，有的双系统，有的单系统)
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = true;  # 自动检测 Windows
    configurationLimit = 10;  # 保留最近 10 个配置
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = null;  # 启动时必须手动选择，不自动跳过

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
