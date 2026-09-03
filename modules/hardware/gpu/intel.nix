{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf (config.mySystem.hardware.gpu == "intel") {
    boot.initrd.kernelModules = ["i915"];

    hardware.graphics.extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      libva-vdpau-driver
      libvdpau-va-gl
    ];

    environment.sessionVariables.LIBVA_DRIVER_NAME = "iHD";
  };
}
