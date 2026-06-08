{
  lib,
  appimageTools,
  fetchurl,
  webkitgtk_4_1,
  gtk3,
  libsoup_3,
  glib-networking,
}:

let
  version = "3.16.1";

  src = fetchurl {
    url = "https://github.com/farion1231/cc-switch/releases/download/v${version}/CC-Switch-v${version}-Linux-x86_64.AppImage";
    hash = "sha256-N/vud3lPRaTuDnUsNGSkWR+ez1jOCMw+6ji+5EZp0TQ=";
  };

  appimageContents = appimageTools.extract {
    pname = "cc-switch";
    inherit version src;
  };
in
appimageTools.wrapType2 {
  pname = "cc-switch";
  inherit version src;

  extraPkgs = _: [
    webkitgtk_4_1
    gtk3
    libsoup_3
    glib-networking
  ];

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/usr/share/applications/*.desktop -t $out/share/applications

    substituteInPlace "$out/share/applications/"*.desktop \
      --replace-fail 'Exec=cc-switch' "Exec=$out/bin/cc-switch"

    cp -r ${appimageContents}/usr/share/icons $out/share/
  '';

  meta = {
    description = "Claude Code, Codex, Gemini CLI and OpenCode provider switcher";
    homepage = "https://github.com/farion1231/cc-switch";
    license = lib.licenses.asl20;
    mainProgram = "cc-switch";
    platforms = [ "x86_64-linux" ];
  };
}
