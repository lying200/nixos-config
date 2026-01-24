{ pkgs, ... }:

{
  # AMD GPU
  hardware.enableRedistributableFirmware = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.kernelModules = [ "amdgpu" ];

  # 硬件传感器支持
  boot.kernelModules = [ "amdgpu" "k10temp" ];

  # OpenCL 支持
  hardware.graphics.extraPackages = [
    pkgs.rocmPackages.clr.icd
  ];
}
