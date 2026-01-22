{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    jetbrains-toolbox
    vscode
    wechat
    google-chrome
  ];
  
}
