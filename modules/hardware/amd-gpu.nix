{ config, lib, pkgs, ... }:

with lib;

{
  options.mySystem.hardware.amdgpu = {
    enable = mkEnableOption "AMD GPU support with AMDGPU driver";
  };

  config = mkIf config.mySystem.hardware.amdgpu.enable {
    # 启用专有固件
    hardware.enableRedistributableFirmware = true;

    # 使用最新内核（AMD GPU 驱动更新快）
    boot.kernelPackages = pkgs.linuxPackages_latest;

    # 加载 AMDGPU 驱动
    boot.initrd.kernelModules = [ "amdgpu" ];
    boot.kernelModules = [ "amdgpu" "k10temp" ];  # k10temp 用于 CPU 温度监控

    # OpenCL 支持（GPU 计算）
    hardware.graphics.extraPackages = [
      pkgs.rocmPackages.clr.icd
    ];
  };
}
