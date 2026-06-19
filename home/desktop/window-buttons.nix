{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellScriptBin "desktop-window-buttons" ''
      case "$1" in
        hide)
          ${pkgs.glib}/bin/gsettings set org.gnome.desktop.wm.preferences button-layout ""
          ;;
        show)
          ${pkgs.glib}/bin/gsettings set org.gnome.desktop.wm.preferences button-layout appmenu:minimize,maximize,close
          ;;
        *)
          echo "usage: desktop-window-buttons hide|show" >&2
          exit 2
          ;;
      esac
    '')
  ];
}
