{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ./configuration.nix

    ../../modules/core/locale.nix
    ../../modules/core/fonts.nix
    ../../modules/core/base-packages.nix
    ../../modules/core/nix.nix
    ../../modules/core/compatibility.nix

    ../../modules/hardware/amd-gpu.nix
    ../../modules/hardware/nvidia-gpu.nix
    ../../modules/hardware/intel-gpu.nix
    ../../modules/hardware/power-management.nix

    ../../modules/desktop/wayland.nix
    ../../modules/desktop/gnome.nix
    ../../modules/desktop/niri.nix
    ../../modules/desktop/monitoring.nix

    ../../modules/services/tailscale.nix
    ../../modules/services/sunshine.nix
    ../../modules/services/podman.nix
    ../../modules/services/k3s.nix
    ../../modules/services/flatpak.nix
    ../../modules/services/printing.nix
    ../../modules/services/mihomo.nix

    ../../modules/programs/fcitx5.nix
    ../../modules/programs/qqmusic.nix
    ../../modules/programs/dev-tools.nix
    ../../modules/programs/default-shell.nix
    ../../modules/programs/steam.nix
    ../../modules/programs/nix-ld.nix
  ];

  mySystem = {
    hardware = {
      nvidia.enable = true;
      powerManagement.enable = true;
    };

    desktop = {
      gnome.enable = true;
      niri.enable = true;
      wayland.enable = true;
      monitoring.enable = true;
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
      steam.enable = true;
    };
  };
}
