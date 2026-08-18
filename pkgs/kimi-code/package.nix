{
  lib,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  makeBinaryWrapper,
  unzip,
  gcc,
  ripgrep,
  fd,
}:
let
  version = "0.37.0";

  platforms = {
    "x86_64-linux" = {
      asset = "linux-x64";
      hash = "sha256-8pOiOf/kKGBI9QJUbpaffmKVX71yQo0EX+RSJkHi+x0=";
    };
    "aarch64-linux" = {
      asset = "linux-arm64";
      hash = "sha256-iHtVU4EEnkWJxwbd/R3ESn731B6b+psyxq8LPEiHJaM=";
    };
  };

  platform =
    platforms.${stdenvNoCC.hostPlatform.system}
      or (throw "Unsupported platform: ${stdenvNoCC.hostPlatform.system}");
in
stdenvNoCC.mkDerivation {
  pname = "kimi-code";
  inherit version;

  src = fetchurl {
    url = "https://github.com/MoonshotAI/kimi-code/releases/download/%40moonshot-ai%2Fkimi-code%40${version}/kimi-code-${platform.asset}.zip";
    inherit (platform) hash;
  };

  dontUnpack = true;
  dontBuild = true;
  dontStrip = true;

  nativeBuildInputs = [
    autoPatchelfHook
    makeBinaryWrapper
    unzip
  ];

  buildInputs = [ gcc.cc.lib ];

  strictDeps = true;

  installPhase = ''
    runHook preInstall

    unzip "$src" -d unpacked
    install -Dm755 unpacked/kimi "$out/bin/kimi"

    wrapProgram "$out/bin/kimi" \
      --set KIMI_CODE_NO_AUTO_UPDATE 1 \
      --prefix PATH : ${
        lib.makeBinPath [
          ripgrep
          fd
        ]
      }

    runHook postInstall
  '';

  meta = {
    description = "AI coding agent for the terminal from Moonshot AI";
    homepage = "https://github.com/MoonshotAI/kimi-code";
    license = lib.licenses.mit;
    mainProgram = "kimi";
    platforms = builtins.attrNames platforms;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
