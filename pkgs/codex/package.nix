{
  lib,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  installShellFiles,
  makeBinaryWrapper,
  runCommand,
  symlinkJoin,
  libcap,
  zlib,
  openssl,
  gcc,
  ripgrep,
  bubblewrap,
}:
let
  stdenv = stdenvNoCC;
  version = "0.121.0";

  platforms = {
    "x86_64-linux" = {
      target = "x86_64-unknown-linux-gnu";
      hash = "sha256-8FOsgenGdpkg+e41ZqutR6sIVut+55JChoFmTs4RNDA=";
    };
    "aarch64-linux" = {
      target = "aarch64-unknown-linux-gnu";
      hash = "sha256-nOXt1VJImK0ulbWfJ4l34xJybgWHlX0fEO44kHD+UDQ=";
    };
  };

  platform = platforms.${stdenv.hostPlatform.system}
    or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");

  codex-unwrapped = stdenv.mkDerivation {
    pname = "codex-unwrapped";
    inherit version;

    src = fetchurl {
      url = "https://github.com/openai/codex/releases/download/rust-v${version}/codex-${platform.target}.tar.gz";
      hash = platform.hash;
    };

    dontUnpack = true;
    dontBuild = true;
    dontStrip = true;

    nativeBuildInputs = [
      autoPatchelfHook
      makeBinaryWrapper
    ];

    buildInputs = [
      libcap
      zlib
      openssl
      gcc.cc.lib
    ];

    strictDeps = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      tar -xzf $src -C $out/bin
      mv $out/bin/codex-${platform.target} $out/bin/codex

      wrapProgram $out/bin/codex \
        --prefix PATH : ${
          lib.makeBinPath (
            [ ripgrep ]
            ++ lib.optionals stdenv.hostPlatform.isLinux [ bubblewrap ]
          )
        }

      runHook postInstall
    '';
  };

  codex-completions = runCommand "codex-completions-${version}" {
    nativeBuildInputs = [ installShellFiles ];
  } ''
    installShellCompletion --cmd codex \
      --bash <(${codex-unwrapped}/bin/codex completion bash) \
      --fish <(${codex-unwrapped}/bin/codex completion fish) \
      --zsh <(${codex-unwrapped}/bin/codex completion zsh)
  '';
in
symlinkJoin {
  name = "codex-${version}";
  paths = [ codex-unwrapped codex-completions ];

  meta = {
    description = "Lightweight coding agent that runs in your terminal";
    homepage = "https://github.com/openai/codex";
    license = lib.licenses.asl20;
    mainProgram = "codex";
    platforms = builtins.attrNames platforms;
  };
}
