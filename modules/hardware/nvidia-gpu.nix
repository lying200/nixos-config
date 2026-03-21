{ config, lib, pkgs, ... }:

with lib;

{
  options.mySystem.hardware.nvidia = {
    enable = mkEnableOption "NVIDIA GPU support with proprietary drivers";

    prime = {
      enable = mkEnableOption "NVIDIA Prime support (for laptops with hybrid graphics)";

      offload = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = "Enable NVIDIA Prime offload mode";
        };

        enableOffloadCmd = mkOption {
          type = types.bool;
          default = false;
          description = "Expose the nvidia-offload command";
        };
      };

      # 如果启用 Prime，需要指定 Bus ID
      nvidiaBusId = mkOption {
        type = types.str;
        default = "";
        example = "PCI:1:0:0";
        description = "NVIDIA GPU PCI Bus ID (use lspci | grep -i nvidia to find)";
      };

      intelBusId = mkOption {
        type = types.str;
        default = "";
        example = "PCI:0:2:0";
        description = "Intel iGPU PCI Bus ID (use lspci | grep -i vga to find)";
      };

      amdBusId = mkOption {
        type = types.str;
        default = "";
        example = "PCI:6:0:0";
        description = "AMD iGPU PCI Bus ID (use lspci | grep -i vga to find)";
      };
    };
  };

  config = mkIf config.mySystem.hardware.nvidia.enable {
    hardware.enableRedistributableFirmware = true;

    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      # 使用开源内核模块（推荐，从 515 版本开始）
      open = mkDefault true;

      nvidiaSettings = true;

      package = config.boot.kernelPackages.nvidiaPackages.stable;

      powerManagement.enable = mkDefault true;

      # Wayland 必需
      modesetting.enable = true;
    };

    hardware.nvidia.prime = mkIf config.mySystem.hardware.nvidia.prime.enable (
      let
        primeCfg = config.mySystem.hardware.nvidia.prime;
      in {
      # Offload 模式（省电，按需使用独显）
      offload = {
        enable = primeCfg.offload.enable;
        enableOffloadCmd = primeCfg.offload.enableOffloadCmd;
      };

      nvidiaBusId = mkIf (primeCfg.nvidiaBusId != "")
        primeCfg.nvidiaBusId;

      intelBusId = mkIf (primeCfg.intelBusId != "")
        primeCfg.intelBusId;

      amdgpuBusId = mkIf (primeCfg.amdBusId != "")
        primeCfg.amdBusId;
    });

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    # 改善兼容性
    environment.sessionVariables = mkIf config.mySystem.hardware.nvidia.enable {
      LIBVA_DRIVER_NAME = "nvidia";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      GBM_BACKEND = "nvidia-drm";
    };
  };
}
