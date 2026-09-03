{...}: {
  imports = [
    ./hardware.nix
    ./configuration.nix
    ../../modules
  ];

  mySystem = {
    core.fonts.enable = true;

    hardware = {
      gpu = "nvidia";
      bluetooth.enable = true;
      powerManagement.enable = true;
    };

    services = {
      tailscale.enable = true;
      podman.enable = true;
      k3s.enable = true;
      flatpak.enable = true;
      printing.enable = true;
      mihomo.enable = true;
    };

    programs = {
      qqmusic.enable = true;
      steam.enable = true;
    };
  };
}
