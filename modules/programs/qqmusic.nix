{ pkgs, ... }:

{
  # QQ 音乐配置
  # 由于 QQ 音乐在 Wayland 下存在显示问题，使用 X11 后端运行
  environment.systemPackages = [
    (pkgs.symlinkJoin {
      name = "qqmusic-wrapped";
      paths = [ pkgs.qqmusic ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/qqmusic \
          --set GDK_BACKEND "x11" \
          --prefix LD_LIBRARY_PATH : "${pkgs.lib.makeLibraryPath [ pkgs.wayland ]}"
      '';
    })
  ];
}
