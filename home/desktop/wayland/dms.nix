{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  useDms = config.myHome.desktop.wayland.shell == "dms";
  dmsSettings = builtins.fromJSON (builtins.readFile ./dms-settings.json);

  # DMS does not currently expose a mode where only the focused Running Apps
  # item is expanded, nor does it expose colors for that item.
  runningAppsFocusedTitleWidth = 80;
  runningAppsFocusedColor = "#2563eb";
  runningAppsFocusedHoverColor = "#1d4ed8";
  runningAppsFocusedTextColor = "#ffffff";
  dmsPackage = inputs.dms.packages.${pkgs.stdenv.hostPlatform.system}.dms-shell.overrideAttrs (old: {
    postInstall =
      (old.postInstall or "")
      + ''
        runningApps="$out/share/quickshell/dms/Modules/DankBar/Widgets/RunningApps.qml"
        chmod u+w "$runningApps" "$(dirname "$runningApps")"
        substituteInPlace "$runningApps" \
          --replace-fail \
            'return mouseArea.containsMouse ? Theme.primarySelected : Theme.withAlpha(Theme.primary, 0.45);' \
            'return mouseArea.containsMouse ? "${runningAppsFocusedHoverColor}" : "${runningAppsFocusedColor}";'

        # Keep inactive windows compact while expanding the focused window.
        compactExpression='(widgetData?.runningAppsCompactMode !== undefined ? widgetData.runningAppsCompactMode : SettingsData.runningAppsCompactMode)'
        substituteInPlace "$runningApps" \
          --replace-fail "$compactExpression" 'delegateItem.isCompact' \
          --replace-fail \
            '(root.iconCellSize + Theme.spacingXS + 120)' \
            '(root.iconCellSize + Theme.spacingXS + ${toString runningAppsFocusedTitleWidth})'
        test "$(grep -Fc 'delegateItem.isCompact' "$runningApps")" -eq 10
        sed -i \
          '/property bool isFocused: isGrouped ? (root.focusedAppId === appId) : (toplevelData ? toplevelData.activated : false)/a\                    readonly property bool isCompact: (widgetData?.runningAppsCompactMode !== undefined ? widgetData.runningAppsCompactMode : SettingsData.runningAppsCompactMode) \&\& !isFocused' \
          "$runningApps"
        test "$(grep -Fc 'readonly property bool isCompact:' "$runningApps")" -eq 2

        sed -i \
          '/font.pixelSize: Theme.barTextSize(barThickness, barConfig?.fontScale, barConfig?.maximizeWidgetText)/{n;s/color: Theme.widgetTextColor/color: isFocused ? "${runningAppsFocusedTextColor}" : Theme.widgetTextColor/;}' \
          "$runningApps"
        test "$(grep -Fc 'color: isFocused ? "${runningAppsFocusedTextColor}" : Theme.widgetTextColor' "$runningApps")" -eq 2
      '';
  });
in {
  imports = [
    inputs.dms.homeModules.dank-material-shell
  ];

  config = lib.mkIf useDms {
    programs.dank-material-shell = {
      enable = true;
      package = dmsPackage;
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
      ];
      # DMS/Quickshell inherits QT_IM_MODULE=fcitx from the desktop session.
      # Let it use Wayland's native input path to avoid Niri's red-screen bug.
      UnsetEnvironment = ["QT_IM_MODULE"];
    };
  };
}
