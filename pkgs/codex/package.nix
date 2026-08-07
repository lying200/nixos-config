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
  version = "0.147.0";

  platforms = {
    "x86_64-linux" = {
      target = "x86_64-unknown-linux-musl";
      codexHash = "sha256-Akbi53ODTgfw+1JJ7W660S5FkeYI+Me7l91qlpBUTDY=";
      codeModeHostHash = "sha256-AUat+qyDY+yfzbWJX3Yk21suhheig4h5OLf7l6HdQ1Y=";
    };
    "aarch64-linux" = {
      target = "aarch64-unknown-linux-musl";
      codexHash = "sha256-62d8gPZmsauLSx0IO2bo1hSxKB2WC7b5/Yypj1izi5A=";
      codeModeHostHash = "sha256-39T/mOpNsw7QeK+cMbb4bj2kg20Fc6qH4iXlpbVNPHw=";
    };
  };

  platform =
    platforms.${stdenv.hostPlatform.system}
      or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");

  codex-unwrapped = stdenv.mkDerivation {
    pname = "codex-unwrapped";
    inherit version;

    src = fetchurl {
      url = "https://github.com/openai/codex/releases/download/rust-v${version}/codex-${platform.target}.tar.gz";
      hash = platform.codexHash;
    };

    codeModeHostSrc = fetchurl {
      url = "https://github.com/openai/codex/releases/download/rust-v${version}/codex-code-mode-host-${platform.target}.tar.gz";
      hash = platform.codeModeHostHash;
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

      mkdir -p "$out/bin"

      tar -xzf "$src" -C "$out/bin"
      mv \
        "$out/bin/codex-${platform.target}" \
        "$out/bin/codex"

      tar -xzf "$codeModeHostSrc" -C "$out/bin"

      if [[ -e "$out/bin/codex-code-mode-host-${platform.target}" ]]; then
        mv \
          "$out/bin/codex-code-mode-host-${platform.target}" \
          "$out/bin/codex-code-mode-host"
      fi

      if [[ ! -x "$out/bin/codex" ]]; then
        echo "Codex executable was not found after extraction" >&2
        exit 1
      fi

      if [[ ! -x "$out/bin/codex-code-mode-host" ]]; then
        echo "Code Mode host executable was not found after extraction" >&2
        exit 1
      fi

      wrapProgram "$out/bin/codex" \
        --prefix PATH : ${
          lib.makeBinPath ([ ripgrep ] ++ lib.optionals stdenv.hostPlatform.isLinux [ bubblewrap ])
        }

      runHook postInstall
    '';
  };

  codex-completions =
    runCommand "codex-completions-${version}"
      {
        nativeBuildInputs = [ installShellFiles ];
      }
      ''
        installShellCompletion --cmd codex \
          --bash <(${codex-unwrapped}/bin/codex completion bash) \
          --fish <(${codex-unwrapped}/bin/codex completion fish) \
          --zsh <(${codex-unwrapped}/bin/codex completion zsh)
      '';
in
symlinkJoin {
  name = "codex-${version}";

  paths = [
    codex-unwrapped
    codex-completions
  ];

  meta = {
    description = "Lightweight coding agent that runs in your terminal";
    homepage = "https://github.com/openai/codex";
    license = lib.licenses.asl20;
    mainProgram = "codex";
    platforms = builtins.attrNames platforms;
  };
}
