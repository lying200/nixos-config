{ pkgs, username, hostname, ... }:

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

      set -gx NIXOS_CONFIG_DIR /home/${username}/nixos-config
    '';

    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake /home/${username}/nixos-config#${hostname}";
      update = "cd /home/${username}/nixos-config && sudo nix flake update && rebuild";
      clean = "sudo nix-collect-garbage -d && sudo nix-store --optimise";

      nixcfg = "cd /home/${username}/nixos-config";

      # 提示用户需要在外部终端执行
      rebuild-help = "echo '⚠️  Please run this in a real terminal (Ghostty/Gnome Terminal), not in IDEA'";

      # 不需要 sudo
      rebuild-check = "nixos-rebuild build --flake /home/${username}/nixos-config#${hostname}";

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

    functions = {
      idea = {
        description = "启动 IntelliJ IDEA Ultimate";
        body = ''
          set -l target $argv
          if test (count $argv) -eq 0
            set target "."
          end
          nohup idea $target > /dev/null 2>&1 &
        '';
      };

      rust-rover = {
        description = "启动 RustRover";
        body = ''
          set -l target $argv
          if test (count $argv) -eq 0
            set target "."
          end
          nohup rust-rover $target > /dev/null 2>&1 &
        '';
      };

      datagrip = {
        description = "启动 DataGrip";
        body = ''
          set -l target $argv
          if test (count $argv) -eq 0
            set target "."
          end
          nohup datagrip $target > /dev/null 2>&1 &
        '';
      };

      webstorm = {
        description = "启动 WebStorm";
        body = ''
          set -l target $argv
          if test (count $argv) -eq 0
            set target "."
          end
          nohup webstorm $target > /dev/null 2>&1 &
        '';
      };

      goland = {
        description = "启动 GoLand";
        body = ''
          set -l target $argv
          if test (count $argv) -eq 0
            set target "."
          end
          nohup goland $target > /dev/null 2>&1 &
        '';
      };

      pycharm = {
        description = "启动 PyCharm";
        body = ''
          set -l target $argv
          if test (count $argv) -eq 0
            set target "."
          end
          nohup pycharm $target > /dev/null 2>&1 &
        '';
      };
    };

    plugins = [
      {
        name = "fzf.fish";
        src = pkgs.fetchFromGitHub {
          owner = "PatrickF1";
          repo = "fzf.fish";
          rev = "8920367cf85eee5218cc25a11e209d46e2591e7a";
          sha256 = "sha256-T8KYLA/r/gOKvAivKRoeqIwE2pINlxFQtZJHpOy9GMM=";
        };
      }
    ];
  };
}
