{ config, inputs, lib, pkgs, ... }:

let
  useDms = config.myHome.desktop.wayland.shell == "dms";
  hiddenTrayIds = [
    "Fcitx::Keyboard - English (US)"
    "Fcitx::键盘 - 英语（美国）"
    "Fcitx::Rime"
    "Fcitx::中州韵"
    "nm-applet"
    "blueman::Bluetooth Disabled"
    "blueman::Bluetooth Enabled"
  ];
  hiddenTrayIdsJson = builtins.toJSON hiddenTrayIds;
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
      ];
      UnsetEnvironment = [
        "QT_IM_MODULE"
      ];
    };

    home.activation.dmsMutableSessionDefaults = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      session_file="$HOME/.local/state/DankMaterialShell/session.json"
      backup_file="$session_file.backup"
      mkdir -p "$(dirname "$session_file")"

      if [ -L "$session_file" ]; then
        if [ -s "$backup_file" ]; then
          cp "$backup_file" "$session_file.tmp"
        else
          printf '{}\n' > "$session_file.tmp"
        fi
        mv -f "$session_file.tmp" "$session_file"
      elif [ ! -s "$session_file" ]; then
        printf '{}\n' > "$session_file"
      fi

      tmp_file="$(mktemp)"
      if ${lib.getExe pkgs.jq} --argjson hidden '${hiddenTrayIdsJson}' \
        '.hiddenTrayIds = (((.hiddenTrayIds // []) + $hidden) | unique)' \
        "$session_file" > "$tmp_file"; then
        mv "$tmp_file" "$session_file"
      else
        rm -f "$tmp_file"
        echo "warning: failed to update DMS session defaults: $session_file" >&2
      fi
    '';
  };
}
