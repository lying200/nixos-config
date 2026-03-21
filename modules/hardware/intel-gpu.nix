{ config, lib, pkgs, ... }:

with lib;

{
  options.mySystem.hardware.intelgpu = {
    enable = mkEnableOption "Intel integrated GPU support";
  };

  config = mkIf config.mySystem.hardware.intelgpu.enable {
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
      LIBVA_DRIVER_NAME = mkForce "iHD";  # 使用 intel-media-driver
    };
  };
}
