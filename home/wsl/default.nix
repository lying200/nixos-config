{ pkgs, lib, ... }:

let
  wslCopy = pkgs.writeShellApplication {
    name = "wsl-copy";
    runtimeInputs = [ pkgs.libiconv ];
    text = ''
      iconv -f UTF-8 -t UTF-16LE | clip.exe
    '';
  };
in
{
  imports = [
    ../common
  ];

  home.packages = [
    wslCopy
  ];

  myHome.programs.zellij.clipboardCommand = lib.getExe wslCopy;
}
