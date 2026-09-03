{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf (config.mySystem.hardware.gpu == "amd") {
    boot.kernelPackages = pkgs.linuxPackages_latest;

    boot.initrd.kernelModules = ["amdgpu"];
    boot.kernelModules = [
      "amdgpu"
      "k10temp"
    ];

    hardware.graphics.extraPackages = [
      pkgs.rocmPackages.clr.icd
    ];
  };
}
