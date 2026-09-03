{
  inputs,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    (jetbrains.idea.override {forceWayland = true;})
    (jetbrains.goland.override {forceWayland = true;})
    (jetbrains.datagrip.override {forceWayland = true;})
    (jetbrains.webstorm.override {forceWayland = true;})
    (jetbrains.rust-rover.override {forceWayland = true;})
    (jetbrains.pycharm.override {forceWayland = true;})

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
