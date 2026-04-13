{ pkgs, ... }:

{
  imports = [
    ../common
  ];

  home.packages = with pkgs; [
    claude-code
    codex
  ];

  programs.zellij.enableFishIntegration = true;
}
