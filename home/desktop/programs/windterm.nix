{ pkgs, ... }:

{
  home.packages = [
    (pkgs.symlinkJoin {
      name = "windterm-wrapped";
      paths = [ pkgs.windterm ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/windterm \
          --prefix QT_QPA_PLATFORM_PLUGIN_PATH : "${pkgs.qt6.qtwayland}/lib/qt-6/plugins/platforms" \
          --set QT_QPA_PLATFORM "wayland;xcb"
      '';
    })
  ];

  xdg.desktopEntries.windterm = {
    name = "WindTerm";
    genericName = "Terminal Emulator";
    comment = "A professional cross-platform SSH/Sftp/Shell/Telnet/Serial terminal";
    exec = "windterm";
    terminal = false;
    categories = [ "System" "TerminalEmulator" ];
    icon = "utilities-terminal";
  };
}
