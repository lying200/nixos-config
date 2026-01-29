{ config, lib, pkgs, ... }:

with lib;

{
  options.mySystem.hardware.intelgpu = {
    enable = mkEnableOption "Intel integrated GPU support";
  };

  config = mkIf config.mySystem.hardware.intelgpu.enable {
    # 启用专有固件
    hardware.enableRedistributableFirmware = true;

    # Intel GPU 驱动（通常已默认启用）
    boot.initrd.kernelModules = [ "i915" ];

    # VA-API 硬件加速
    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver  # 较新的 iGPU (Broadwell+)
        intel-vaapi-driver  # 较旧的 iGPU
        libva-vdpau-driver
        libvdpau-va-gl
      ];
    };

    # 环境变量
    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = mkForce "iHD";  # 使用 intel-media-driver
    };
  };
}
