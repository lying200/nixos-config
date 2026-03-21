{ pkgs, ... }:

{
  home.packages = with pkgs; [
    jetbrains.idea
    jetbrains.goland
    jetbrains.datagrip
    jetbrains.webstorm
    jetbrains.rust-rover
    jetbrains.pycharm

    vscode
    antigravity

    google-chrome

    wechat
    qq
    thunderbird
    telegram-desktop

    gemini-cli

    nautilus
    loupe
    file-roller

    snipaste
    satty

    vlc
    mpv
    obs-studio

    variety

    libreoffice-fresh
    obsidian
    typora

    syncthing
    rclone

    motrix
    flclash

    remmina
    moonlight-qt
  ];
}
