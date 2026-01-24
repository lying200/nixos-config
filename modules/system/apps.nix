{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    jetbrains-toolbox
    vscode
    wechat
    google-chrome
    gemini-cli

    ulauncher
    wmctrl
    snipaste
  ];
}
