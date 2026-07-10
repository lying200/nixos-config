final: prev: {
  claude-code = final.callPackage ../pkgs/claude-code/package.nix { };
  codex = final.callPackage ../pkgs/codex/package.nix { };
  cc-switch = final.callPackage ../pkgs/cc-switch/package.nix { };

  catppuccin-gtk = prev.catppuccin-gtk.overrideAttrs (old: {
    postPatch = (old.postPatch or "") + ''
      # Temporary workaround: Python 3.14's BooleanOptionalAction rejects type=bool.
      substituteInPlace sources/build/args.py install.py \
        --replace-fail "        type=bool," ""
    '';
  });

  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (_python-final: python-prev: {
      click-threading = python-prev.click-threading.overridePythonAttrs (_old: {
        # Temporary workaround: pytest collects docs/conf.py, which imports pkg_resources.
        pytestFlags = [ "tests" ];
      });

      catppuccin = python-prev.catppuccin.overridePythonAttrs (_old: {
        # Temporary workaround: catppuccin 2.5.0 imports removed matplotlib.style.core APIs.
        doCheck = false;
        pythonImportsCheck = [ ];
      });
    })
  ];
}
