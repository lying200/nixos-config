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

    ../../modules/desktop/wayland.nix
    ../../modules/desktop/gnome.nix
    ../../modules/desktop/niri.nix
    ../../modules/desktop/monitoring.nix

    ../../modules/services/tailscale.nix
    ../../modules/services/sunshine.nix
    ../../modules/services/podman.nix
    ../../modules/services/gnome-suspend.nix
    ../../modules/services/flatpak.nix

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
      gnome-suspend.enable = true;
      flatpak.enable = true;
    };

    programs = {
      steam.enable = true;
    };
  };
}
