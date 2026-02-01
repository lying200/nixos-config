{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # 开发环境管理
    devenv                 # 项目级开发环境管理

    # 开发 SDK
    nodejs_24              # Node.js 24 LTS
    jdk25                  # OpenJDK 25 LTS
    python314              # Python 3.14
    go_1_25                # Go 1.25

    # Rust 工具链
    rustup                 # Rust 工具链管理器

    # Rust 构建依赖
    pkg-config
    openssl
    gcc
    cmake
  ];

  # 允许运行未打补丁的动态二进制文件
  # 例如：JetBrains Toolbox 下载的 IDE、AppImage 等
  programs.nix-ld = {
    enable = true;
    # 可选：添加额外的库
    libraries = with pkgs; [
        stdenv.cc.cc.lib
        zlib
        fuse3
        icu
        nss
        openssl
        curl
        expat

        xorg.libX11
        xorg.libXext
        xorg.libXrender
        xorg.libXtst
        xorg.libXi
        xorg.libXcomposite
        xorg.libXdamage
        xorg.libXfixes
        xorg.libXrandr
        xorg.libXcursor
        freetype
        fontconfig
        alsa-lib

        libxkbcommon
        wayland
        gtk3
        glib
        dbus
    ];
  };
}
