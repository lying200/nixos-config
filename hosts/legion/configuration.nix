{ username, ... }:

{
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = true;
    configurationLimit = 10;
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = null;

  networking.hostName = "legion";
  networking.networkmanager.enable = true;

  networking.hosts = {
    "192.168.3.150" = [ "infra.dev.internal" ];
    "192.168.3.160" = [ "ops.dev.internal" ];
  };

  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = [ "networkmanager" "wheel" "video" "input" "uinput" ];
    packages = [ ];
  };

  system.stateVersion = "25.11";
}
