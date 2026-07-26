{ config, lib, pkgs, ... }:

{
  options.mySystem.hardware.amdgpu = {
    enable = lib.mkEnableOption "AMD GPU support with AMDGPU driver";
  };

  config = lib.mkIf config.mySystem.hardware.amdgpu.enable {
    hardware.enableRedistributableFirmware = true;

    # 使用最新内核（AMD GPU 驱动更新快）
    boot.kernelPackages = pkgs.linuxPackages_latest;

    boot.initrd.kernelModules = [ "amdgpu" ];
    boot.kernelModules = [ "amdgpu" "k10temp" ];  # k10temp 用于 CPU 温度监控

    hardware.graphics.enable = true;
    hardware.graphics.extraPackages = [
      pkgs.rocmPackages.clr.icd
    ];
  };
}
