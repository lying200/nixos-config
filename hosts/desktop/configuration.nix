{ username, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "desktop";
  networking.networkmanager.enable = true;

  networking.hosts = {
    "192.168.3.160" = [ "dev.com" ];
  };

  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = [ "networkmanager" "wheel" "video" "input" "uinput" ];
    packages = [ ];
  };

  system.stateVersion = "25.11";
}
