{ pkgs, ... }:

{
  # AMD GPU
  hardware.enableRedistributableFirmware = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.kernelModules = [ "amdgpu" ];
  
  # OpenCL 支持
  hardware.graphics.extraPackages = [
    pkgs.rocmPackages.clr.icd
  ];
}
