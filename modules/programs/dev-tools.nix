{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    devenv
    nodejs_24
  ];
}
