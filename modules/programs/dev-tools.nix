{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    devenv
    nodejs_24
    jdk25
    python314
    go_1_25
  ];
}
