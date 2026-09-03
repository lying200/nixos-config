{
  hosts,
  nixosConfigurations,
  pkgs,
  source,
  userSettings,
}: let
  inherit (pkgs) lib;
  hostNames = builtins.attrNames hosts;
  desktopProfileLib = import ../lib/desktop-profile.nix {inherit lib;};
  desktopProfiles = builtins.filter (profile: profile != null) (
    map (name: hosts.${name}.desktopProfile or null) hostNames
  );
  invalidDesktopProfileRejected =
    lib.all
    (profile:
      !(builtins.tryEval (
        desktopProfileLib.validate (profile // {inputMethod = "typo";})
      )).success)
    desktopProfiles;

  hostNameMatches = name:
    nixosConfigurations.${name}.config.networking.hostName == name;

  desktopProfileMatches = name: let
    host = hosts.${name};
    profile = host.desktopProfile or null;
    config = nixosConfigurations.${name}.config;
    homeConfig = config.home-manager.users.${userSettings.username};
  in
    profile
    == null
    || (
      lib.all
      (feature: config.mySystem.desktop.${feature}.enable == profile.${feature})
      desktopProfileLib.featureNames
      && config.mySystem.programs.fcitx5.enable == (profile.inputMethod == "fcitx5")
      && homeConfig.myHome.desktop.wayland.shell == profile.shell
    );

  dmsUsesNativeInputMethod = name: let
    host = hosts.${name};
    profile = host.desktopProfile or null;
    homeConfig =
      nixosConfigurations.${name}.config.home-manager.users.${userSettings.username};
  in
    profile
    == null
    || profile.shell != "dms"
    || (
      builtins.elem
      "QT_IM_MODULE"
      homeConfig.systemd.user.services.dms.Service.UnsetEnvironment
      && !builtins.hasAttr "dms-fcitx-lock-guard" homeConfig.systemd.user.services
    );

  operationalToolsEnabled = name: let
    config = nixosConfigurations.${name}.config;
  in
    config.programs.nh.enable && config.programs.nix-index.enable;

  flatpakIsManaged = name: let
    config = nixosConfigurations.${name}.config;
  in
    !config.mySystem.services.flatpak.enable
    || builtins.hasAttr "flatpak-flathub" config.systemd.services;

  hostSummary =
    lib.mapAttrs
    (name: host: {
      hostname = nixosConfigurations.${name}.config.networking.hostName;
      gpu = nixosConfigurations.${name}.config.mySystem.hardware.gpu;
      desktop = host.desktopProfile or null;
    })
    hosts;
in
  assert lib.all hostNameMatches hostNames;
  assert lib.all desktopProfileMatches hostNames;
  assert lib.all dmsUsesNativeInputMethod hostNames;
  assert lib.all operationalToolsEnabled hostNames;
  assert invalidDesktopProfileRejected;
  assert lib.all flatpakIsManaged hostNames; {
    host-invariants = pkgs.writeText "host-invariants.json" (builtins.toJSON hostSummary);

    formatting =
      pkgs.runCommand "nix-format-check" {
        nativeBuildInputs = [pkgs.alejandra];
      } ''
        alejandra --check ${source}
        touch $out
      '';

    dead-code =
      pkgs.runCommand "deadnix-check" {
        nativeBuildInputs = [pkgs.deadnix];
      } ''
        deadnix --fail ${source}
        touch $out
      '';

    static-analysis =
      pkgs.runCommand "statix-check" {
        nativeBuildInputs = [pkgs.statix];
      } ''
        statix check ${source}
        touch $out
      '';

    shell =
      pkgs.runCommand "shellcheck" {
        nativeBuildInputs = [pkgs.shellcheck];
      } ''
        shellcheck ${source}/update.sh
        NIXOS_HOST=test ${pkgs.bash}/bin/bash ${source}/update.sh --help >/dev/null
        if NIXOS_HOST=test ${pkgs.bash}/bin/bash ${source}/update.sh --not-a-real-option >/dev/null 2>&1; then
          echo "update.sh accepted an invalid option" >&2
          exit 1
        fi
        touch $out
      '';
  }
