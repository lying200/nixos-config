{
  config,
  lib,
  pkgs,
  ...
}: {
  options.mySystem.services.flatpak = {
    enable = lib.mkEnableOption "Flatpak application manager";
  };

  config = lib.mkIf config.mySystem.services.flatpak.enable {
    services.flatpak.enable = true;
    systemd.services.flatpak-flathub = {
      description = "Ensure the Flathub remote exists";
      wants = ["network-online.target"];
      after = ["network-online.target"];
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        ${lib.getExe pkgs.flatpak} remote-add --system --if-not-exists \
          flathub https://dl.flathub.org/repo/flathub.flatpakrepo
      '';
    };

    # Flatpak 应用集成所需
    xdg.portal = {
      enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
    };
  };
}
