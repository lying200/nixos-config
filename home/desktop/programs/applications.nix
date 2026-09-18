{
  inputs,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    jetbrains.idea
    jetbrains.goland
    jetbrains.datagrip
    jetbrains.webstorm
    jetbrains.rust-rover
    jetbrains.pycharm

    vscode
    inputs.paseo.packages.${pkgs.stdenv.hostPlatform.system}.desktop

    wechat
    qq
    thunderbird
    telegram-desktop

    nautilus
    loupe
    file-roller

    snipaste
    satty

    vlc
    mpv
    tsukimi
    obs-studio

    variety

    libreoffice-stable
    obsidian
    readest
    typora

    syncthing
    rclone

    motrix

    remmina
    moonlight-qt
  ];
}
