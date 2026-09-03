{
  config,
  inputs,
  lib,
  ...
}: let
  useDms = config.myHome.desktop.wayland.shell == "dms";
  dmsSettings = builtins.fromJSON (builtins.readFile ./dms-settings.json);
in {
  imports = [
    inputs.dms.homeModules.dank-material-shell
  ];

  config = lib.mkIf useDms {
    programs.dank-material-shell = {
      enable = true;
      systemd.enable = true;

      settings =
        lib.recursiveUpdate
        dmsSettings
        {
          blurredWallpaperLayer = true;
          blurWallpaperOnOverview = false;
          launchPrefix = "env QT_IM_MODULE=fcitx";
          acLockTimeout = 600;
          batteryLockTimeout = 600;
          acMonitorTimeout = 660;
          batteryMonitorTimeout = 660;
          lockBeforeSuspend = true;
          matugenTemplateGhostty = false;
        };
    };

    systemd.user.services.dms.Service = {
      Environment = [
        "LANG=zh_CN.UTF-8"
        "LC_MESSAGES=zh_CN.UTF-8"
        "DMS_HIDE_TRAYIDS=fcitx,blueman,nm-applet"
        # Unsetting this lets Qt use Wayland's default input method. Force the
        # local compose context so DMS lock-screen passwords stay English-only.
        "QT_IM_MODULE=compose"
      ];
    };
  };
}
