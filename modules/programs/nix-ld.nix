{ pkgs, ... }:

{
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
    openssl
    curl
    glib
    icu
    nss
    expat
    fuse3
  ];
}
