{ config, lib, pkgs, ... }:

let
  cfg = config.myHome.desktop.wayland.lock;
  shell = config.myHome.desktop.wayland.shell;
  useExternalLock = cfg.backend != "shell";

  monitorOffTimer = command: ''
    lock_pid=
    monitor_off_pid=

    cleanup() {
      if [ -n "$monitor_off_pid" ]; then
        kill "$monitor_off_pid" 2>/dev/null || true
      fi
      ${pkgs.niri}/bin/niri msg action power-on-monitors >/dev/null 2>&1 || true
    }

    trap cleanup EXIT INT TERM

    (
      ${command}
    ) &
    lock_pid=$!

    if [ ${lib.boolToString cfg.monitorOff.enable} = true ]; then
      (
        while kill -0 "$lock_pid" 2>/dev/null; do
          sleep ${toString cfg.monitorOff.afterLockSeconds} || exit 0
          kill -0 "$lock_pid" 2>/dev/null || exit 0
          ${pkgs.niri}/bin/niri msg action power-off-monitors >/dev/null 2>&1 || true
        done
      ) &
      monitor_off_pid=$!
    fi

    wait "$lock_pid"
  '';

  withLockGuard = command: ''
    lock_file="''${XDG_RUNTIME_DIR:-/tmp}/lock-screen.lock"
    ${pkgs.util-linux}/bin/flock -n -E 75 "$lock_file" ${pkgs.bash}/bin/bash -c ${lib.escapeShellArg command}
    status=$?
    if [ "$status" -eq 75 ]; then
      exit 0
    fi
    exit "$status"
  '';

  shellLockCommand = {
    dms = ''exec dms ipc call lock lock'';
    noctalia = ''exec noctalia-shell ipc call lockScreen lock'';
    none = ''exec ${pkgs.swaylock}/bin/swaylock -f -c 000000'';
  }.${shell};

  lockCommand = {
    swaylock-effects = monitorOffTimer ''
      ${pkgs.swaylock-effects}/bin/swaylock \
        --screenshots \
        --effect-blur 8x5 \
        --effect-vignette 0.5:0.5 \
        --clock \
        --indicator \
        --indicator-radius 120 \
        --indicator-thickness 8 \
        --ring-color b4befe \
        --key-hl-color cba6f7 \
        --bs-hl-color f38ba8 \
        --inside-color 1e1e2ecc \
        --inside-ver-color 89b4facc \
        --inside-wrong-color f38ba8cc \
        --line-color 00000000 \
        --separator-color 00000000 \
        --text-color cdd6f4 \
        --text-ver-color cdd6f4 \
        --text-wrong-color cdd6f4 \
        --fade-in 0.2
    '';
    swaylock = monitorOffTimer ''
      ${pkgs.swaylock}/bin/swaylock -c 000000
    '';
    shell = shellLockCommand;
  }.${cfg.backend};

  lockScreenPackage = pkgs.writeShellScriptBin "lock-screen" (withLockGuard lockCommand);
in
{
  options.myHome.desktop.wayland.lock = {
    backend = lib.mkOption {
      type = lib.types.enum [ "swaylock-effects" "swaylock" "shell" ];
      default = "swaylock-effects";
      description = ''
        Lock screen backend. Use "shell" to hand locking back to the active
        desktop shell, or a swaylock backend to avoid Quickshell lock surfaces.
      '';
    };

    command = lib.mkOption {
      type = lib.types.str;
      readOnly = true;
      default = "${lockScreenPackage}/bin/lock-screen";
      description = "Absolute command path for the selected lock screen backend.";
    };

    autoLock = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Auto-lock the screen after the configured idle timeout.";
      };

      timeoutSeconds = lib.mkOption {
        type = lib.types.ints.positive;
        default = 600;
        description = "Idle seconds before triggering auto-lock.";
      };
    };

    lockOnSuspend = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Lock the screen before the system suspends or hibernates.";
    };

    monitorOff = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Power off monitors after the lock screen has been active for a while.";
      };

      afterLockSeconds = lib.mkOption {
        type = lib.types.ints.positive;
        default = 60;
        description = "Seconds to wait after locking before powering off monitors.";
      };
    };
  };

  config = {
    home.packages = [ lockScreenPackage ]
      ++ lib.optionals useExternalLock [ pkgs.swayidle ]
      ++ lib.optionals (cfg.backend == "swaylock-effects") [ pkgs.swaylock-effects ]
      ++ lib.optionals (cfg.backend == "swaylock") [ pkgs.swaylock ];

    systemd.user.services.lock-idle = lib.mkIf useExternalLock {
      Unit = {
        Description = "Wayland idle lock manager";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };

      Install.WantedBy = [ "graphical-session.target" ];

      Service = {
        ExecStart = lib.concatStringsSep " " (
          [
            "${pkgs.swayidle}/bin/swayidle"
            "-w"
          ]
          ++ lib.optionals cfg.autoLock.enable [
            "timeout"
            (toString cfg.autoLock.timeoutSeconds)
            (lib.escapeShellArg cfg.command)
          ]
          ++ lib.optionals cfg.lockOnSuspend [
            "before-sleep"
            (lib.escapeShellArg cfg.command)
          ]
          ++ [
            "after-resume"
            (lib.escapeShellArg "${pkgs.niri}/bin/niri msg action power-on-monitors")
          ]
        );
        Restart = "on-failure";
        RestartSec = 2;
      };
    };
  };
}
