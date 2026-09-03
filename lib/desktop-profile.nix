{lib}: let
  featureNames = [
    "gnome"
    "niri"
    "wayland"
    "monitoring"
  ];
  shells = [
    "dms"
    "noctalia"
    "none"
  ];
  inputMethods = [
    "fcitx5"
    "none"
  ];

  isValid = profile:
    lib.all (name: builtins.isBool profile.${name}) featureNames
    && builtins.elem profile.shell shells
    && builtins.elem profile.inputMethod inputMethods;
in {
  inherit featureNames;

  validate = profile:
    assert lib.assertMsg (isValid profile) "Invalid desktop profile"; profile;

  toSystemConfig = profile: {
    desktop = lib.genAttrs featureNames (name: {
      enable = profile.${name};
    });
    programs.fcitx5.enable = profile.inputMethod == "fcitx5";
  };
}
