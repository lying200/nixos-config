{ osConfig ? {}, pkgs, ... }:

let
  useNvidiaVaapi = osConfig.mySystem.hardware.nvidia.enable or false;

  chromeFlags = [
    "--ozone-platform=wayland"
    "--ignore-gpu-blocklist"
    "--use-gl=angle"
    "--use-angle=gl"
    "--enable-features=AcceleratedVideoDecodeLinuxGL,AcceleratedVideoDecodeLinuxZeroCopyGL,VaapiOnNvidiaGPUs,VaapiIgnoreDriverChecks,WaylandWindowDecorations"
    "--disable-features=Vulkan,UseChromeOSDirectVideoDecoder"
  ];

  chromeWithVaapi = pkgs.google-chrome.override {
    commandLineArgs = pkgs.lib.concatStringsSep " " chromeFlags;
  };
in
{
  home.packages = [
    (if useNvidiaVaapi then chromeWithVaapi else pkgs.google-chrome)
  ];
}
