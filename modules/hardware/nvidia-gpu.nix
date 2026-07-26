{ config, lib, ... }:

{
  options.mySystem.hardware.nvidia = {
    enable = lib.mkEnableOption "NVIDIA GPU support with proprietary drivers";
  };

  config = lib.mkIf config.mySystem.hardware.nvidia.enable {
    hardware.enableRedistributableFirmware = true;

    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      # 使用开源内核模块（推荐，从 515 版本开始）
      open = lib.mkDefault true;

      nvidiaSettings = true;

      package = config.boot.kernelPackages.nvidiaPackages.stable;

      powerManagement.enable = lib.mkDefault true;

      # Wayland 必需
      modesetting.enable = true;
    };

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    # 改善兼容性
    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "nvidia";
      NVD_BACKEND = "direct";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      GBM_BACKEND = "nvidia-drm";
    };
  };
}
