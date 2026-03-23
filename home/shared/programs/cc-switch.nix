{ pkgs, ... }:

let
  version = "3.12.2";

  src = pkgs.fetchurl {
    url = "https://github.com/farion1231/cc-switch/releases/download/v${version}/CC-Switch-v${version}-Linux-x86_64.AppImage";
    sha256 = "1zn9vb9gy0id34m95j68xj8kz9wfgmkpann6ahyvb04q6mhb25m8";
  };

  appimageContents = pkgs.appimageTools.extract {
    pname = "cc-switch";
    inherit version src;
  };

  cc-switch = pkgs.appimageTools.wrapType2 {
    pname = "cc-switch";
    inherit version src;

    extraPkgs = pkgs: with pkgs; [
      webkitgtk_4_1
      gtk3
      libsoup_3
      glib-networking
    ];

    extraInstallCommands = ''
      # 安装桌面快捷方式
      install -m 444 -D ${appimageContents}/usr/share/applications/*.desktop -t $out/share/applications

      substituteInPlace "$out/share/applications/"*.desktop \
        --replace-fail 'Exec=cc-switch' "Exec=$out/bin/cc-switch"

      # 复制图标文件
      cp -r ${appimageContents}/usr/share/icons $out/share/
    '';
  };
in
{
  home.packages = [ cc-switch ];
}
