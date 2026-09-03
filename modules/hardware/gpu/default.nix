{
  config,
  lib,
  ...
}: let
  cfg = config.mySystem.hardware;
in {
  imports = [
    ./amd.nix
    ./intel.nix
    ./nvidia.nix
  ];

  options.mySystem.hardware.gpu = lib.mkOption {
    type = lib.types.enum [
      "none"
      "amd"
      "intel"
      "nvidia"
    ];
    default = "none";
    description = "GPU adapter used by this host.";
  };

  config = lib.mkIf (cfg.gpu != "none") {
    hardware.enableRedistributableFirmware = true;
    hardware.graphics.enable = true;
  };
}
