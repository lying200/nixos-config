{ config, inputs, lib, ... }:

let
  useDms = config.myHome.desktop.wayland.shell == "dms";
in
{
  imports = [
    inputs.dms.homeModules.dank-material-shell
  ];

  config = lib.mkIf useDms {
    programs.dank-material-shell = {
      enable = true;
      systemd.enable = true;

      settings = lib.recursiveUpdate
        (builtins.fromJSON (builtins.readFile ./dms-settings.json))
        {
          blurredWallpaperLayer = true;
          blurWallpaperOnOverview = false;
          launchPrefix = "env QT_IM_MODULE=fcitx";
          acLockTimeout = 600;
          batteryLockTimeout = 600;
          acMonitorTimeout = 660;
          batteryMonitorTimeout = 660;
          lockBeforeSuspend = true;
        };
    };

    systemd.user.services.dms.Service = {
      Environment = [
        "LANG=zh_CN.UTF-8"
        "LC_MESSAGES=zh_CN.UTF-8"
        "DMS_HIDE_TRAYIDS=fcitx,blueman,nm-applet"
      ];
      UnsetEnvironment = [
        "QT_IM_MODULE"
      ];
    };
  };
}
