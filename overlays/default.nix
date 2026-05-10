final: prev: {
  claude-code = final.callPackage ../pkgs/claude-code/package.nix { };
  codex = final.callPackage ../pkgs/codex/package.nix { };
  cc-switch = final.callPackage ../pkgs/cc-switch/package.nix { };
}
