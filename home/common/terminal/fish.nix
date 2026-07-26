{ config, pkgs, hostname, ... }:

let
  configDir = "${config.home.homeDirectory}/nixos-config";
in
{
  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      set -g fish_greeting

      set -gx LS_COLORS 'di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'

      fish_vi_key_bindings

      # jk 映射为 Esc 退出插入模式
      bind -M insert jk "if commandline -P; commandline -f cancel; else; set fish_bind_mode default; commandline -f repaint; end"

      bind -M insert \ce accept-autosuggestion
      bind -M insert \cf forward-word

      zoxide init fish | source

      set -gx NIXOS_CONFIG_DIR ${configDir}
    '';

    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake ${configDir}#${hostname}";
      update = "cd ${configDir} && ./update.sh";
      clean = "sudo nix-collect-garbage -d && sudo nix-store --optimise";

      nixcfg = "cd ${configDir}";

      rebuild-check = "nixos-rebuild build --flake ${configDir}#${hostname}";

      ll = "eza -la --icons --git";
      ls = "eza --icons";
      l = "eza -l --icons";
      tree = "eza --tree --icons";
      cat = "bat";

      g = "git";
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git log --oneline --graph";

      ".." = "cd ..";
      "..." = "cd ../..";

      cd = "z";
    };

    plugins = [
      {
        name = "fzf.fish";
        inherit (pkgs.fishPlugins.fzf-fish) src;
      }
    ];
  };
}
