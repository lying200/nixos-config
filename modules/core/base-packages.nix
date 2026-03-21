{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    git vim wget curl

    mesa-demos
    vulkan-tools
    pciutils
    usbutils
    lshw
    inxi

    psmisc
    procps

    nmap
    iperf3
    dig
    traceroute

    tree
    ripgrep
    fd
    unzip zip
    p7zip

    btop
    iotop

    jq

    xdg-utils

    fastfetch
  ];
}
