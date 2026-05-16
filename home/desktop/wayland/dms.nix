{ config, inputs, lib, ... }:

let
  useDms = config.myHome.desktop.wayland.shell == "dms";
  lockCfg = config.myHome.desktop.wayland.lock;
  useExternalLock = lockCfg.backend != "shell";
  lockCommand = lockCfg.command;
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
        (lib.optionalAttrs useExternalLock ({
          customPowerActionLock = lockCommand;
          fadeToLockEnabled = false;
          loginctlLockIntegration = false;
          lockBeforeSuspend = false;
          acLockTimeout = 0;
          batteryLockTimeout = 0;
          acMonitorTimeout = 0;
          batteryMonitorTimeout = 0;
        }));
    };
  };
}
