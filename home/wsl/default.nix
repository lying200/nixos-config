{ pkgs, ... }:

{
  imports = [
    ../common
  ];

  home.packages = with pkgs; [
    claude-code
  ];
}
