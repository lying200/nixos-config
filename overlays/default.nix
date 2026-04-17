final: prev: {
  claude-code = final.callPackage ../pkgs/claude-code/package.nix { };
  codex = final.callPackage ../pkgs/codex/package.nix { };
}
