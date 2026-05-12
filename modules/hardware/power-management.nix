{ config, lib, ... }:

with lib;

{
  options.mySystem.hardware.powerManagement = {
    enable = mkEnableOption "laptop power management with TLP";
  };

  config = mkIf config.mySystem.hardware.powerManagement.enable {
    powerManagement.enable = true;

    # GNOME enables power-profiles-daemon by default; TLP and PPD both tune the
    # same kernel controls, so keep one owner and expose TLP's replacement D-Bus API.
    services.power-profiles-daemon.enable = false;
    services.auto-cpufreq.enable = false;

    services.tlp = {
      enable = true;
      pd.enable = true;

      settings = {
        PLATFORM_PROFILE_ON_AC = "balanced";
        PLATFORM_PROFILE_ON_BAT = "balanced";
        PLATFORM_PROFILE_ON_SAV = "low-power";

        # Lenovo non-ThinkPad/Legion exposes a fixed conservation mode, not
        # arbitrary 75/80 thresholds. 1 enables Long_Life, 0 disables it.
        START_CHARGE_THRESH_BAT0 = 0;
        STOP_CHARGE_THRESH_BAT0 = 1;
        RESTORE_THRESHOLDS_ON_BAT = 1;
      };
    };
  };
}
