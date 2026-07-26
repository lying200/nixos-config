{ config, lib, pkgs, ... }:

{
  options.mySystem.hardware.intelgpu = {
    enable = lib.mkEnableOption "Intel integrated GPU support";
  };

  config = lib.mkIf config.mySystem.hardware.intelgpu.enable {
    hardware.enableRedistributableFirmware = true;

    boot.initrd.kernelModules = [ "i915" ];

    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver  # 较新的 iGPU (Broadwell+)
        intel-vaapi-driver  # 较旧的 iGPU
        libva-vdpau-driver
        libvdpau-va-gl
      ];
    };

    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "iHD";  # 使用 intel-media-driver；与 nvidia 模块互斥，同时启用会显式报冲突
    };
  };
}
