{ pkgs, ... }:

{
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc  # 提供 libstdc++
    zlib          # 压缩库
    openssl       # 安全网络连接
    curl          # 网络传输
    glib          # 通用实用程序库

    icu
    nss
    expat
    fuse3
  ];
}
