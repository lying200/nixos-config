{
  config,
  lib,
  ...
}: {
  config = lib.mkIf (config.mySystem.hardware.gpu == "nvidia") {
    services.xserver.videoDrivers = ["nvidia"];

    hardware.nvidia = {
      open = lib.mkDefault true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      powerManagement.enable = lib.mkDefault true;
      modesetting.enable = true;
    };

    hardware.graphics.enable32Bit = true;

    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "nvidia";
      NVD_BACKEND = "direct";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      GBM_BACKEND = "nvidia-drm";
    };
  };
}
