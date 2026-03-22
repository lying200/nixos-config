{ config, lib, pkgs, ... }:

with lib;

{
  options.mySystem.desktop.wayland = {
    enable = mkEnableOption "Wayland environment support";
  };

  config = mkIf config.mySystem.desktop.wayland.enable {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;

    security.polkit.enable = true;

    environment.sessionVariables = {
      NIXOS_OZONE_WL = lib.mkDefault "1";
      QT_QPA_PLATFORM = lib.mkDefault "wayland";
      SDL_VIDEODRIVER = lib.mkDefault "wayland";
      XDG_SESSION_TYPE = "wayland";
    };
  };
}
