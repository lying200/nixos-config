{ config, pkgs, inputs, lib, ... }:

let
  useNoctalia = config.myHome.desktop.wayland.shell == "noctalia";
  lockCfg = config.myHome.desktop.wayland.lock;
  useExternalLock = lockCfg.backend != "shell";
  lockCommand = lockCfg.command;

  lockOverrides = lib.optionalAttrs useExternalLock {
    idle = {
      enabled = false;
      screenOffTimeout = 0;
      lockTimeout = 0;
      suspendTimeout = 0;
      screenOffCommand = "";
      lockCommand = lockCommand;
      suspendCommand = "";
      resumeScreenOffCommand = "";
      resumeLockCommand = "";
      resumeSuspendCommand = "";
    };
    general.lockOnSuspend = false;
  };
in
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  config = lib.mkIf useNoctalia {
    programs.noctalia-shell = {
      enable = true;

      settings = lib.recursiveUpdate
        (builtins.fromJSON (builtins.readFile ./noctalia-settings.json))
        lockOverrides;

      plugins = {
        sources = [
          {
            enabled = true;
            name = "Noctalia Plugins";
            url = "https://github.com/noctalia-dev/noctalia-plugins";
          }
        ];
        states = {
          clipper = {
            enabled = true;
            sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
          };
        };
        version = 2;
      };
    };

    home.packages = with pkgs; [
      brightnessctl
      imagemagick
      python3
      git
      cliphist
      wlsunset
    ];
  };
}
