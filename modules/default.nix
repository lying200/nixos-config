{...}: {
  imports = [
    ./core/base-packages.nix
    ./core/compatibility.nix
    ./core/fonts.nix
    ./core/locale.nix
    ./core/nix.nix

    ./hardware/bluetooth.nix
    ./hardware/gpu
    ./hardware/power-management.nix

    ./desktop/gnome.nix
    ./desktop/monitoring.nix
    ./desktop/niri.nix
    ./desktop/wayland.nix

    ./services/flatpak.nix
    ./services/k3s.nix
    ./services/mihomo.nix
    ./services/podman.nix
    ./services/printing.nix
    ./services/sunshine.nix
    ./services/tailscale.nix

    ./programs/default-shell.nix
    ./programs/dev-tools.nix
    ./programs/fcitx5.nix
    ./programs/nix-ld.nix
    ./programs/qqmusic.nix
    ./programs/steam.nix
  ];
}
