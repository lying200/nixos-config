{ pkgs, username, hostname, ... }:

{
  programs.fish = {
    enable = true;

    # 交互式 Shell 初始化
    interactiveShellInit = ''
      # 禁用欢迎消息
      set -g fish_greeting

      # 更好的 ls 颜色
      set -gx LS_COLORS 'di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'

      # 启用 vi 模式
      fish_vi_key_bindings

      # jk 映射为 Esc 退出插入模式
      bind -M insert jk "if commandline -P; commandline -f cancel; else; set fish_bind_mode default; commandline -f repaint; end"

      # 在 vi 插入模式下的自动建议快捷键
      bind -M insert \ce accept-autosuggestion  # Ctrl+E 接受整个建议
      bind -M insert \cf forward-word          # Ctrl+F 接受一个词

      # zoxide 初始化
      zoxide init fish | source

      # NixOS 配置路径
      set -gx NIXOS_CONFIG_DIR /home/${username}/nixos-config
    '';

    # Shell 别名
    shellAliases = {
      # 系统管理
      rebuild = "sudo nixos-rebuild switch --flake /home/${username}/nixos-config#${hostname}";
      update = "cd /home/${username}/nixos-config && sudo nix flake update && rebuild";
      clean = "sudo nix-collect-garbage -d && sudo nix-store --optimise";

      # 快速进入配置目录
      nixcfg = "cd /home/${username}/nixos-config";

      # 无 sudo 版本（在 IDEA 中使用）
      # 提示用户需要在外部终端执行
      rebuild-help = "echo '⚠️  Please run this in a real terminal (Ghostty/Gnome Terminal), not in IDEA'";

      # 预览配置变更（不需要 sudo）
      rebuild-check = "nixos-rebuild build --flake /home/${username}/nixos-config#${hostname}";

      # 常用命令增强
      ll = "eza -la --icons --git";
      ls = "eza --icons";
      l = "eza -l --icons";
      tree = "eza --tree --icons";
      cat = "bat";

      # Git 简写
      g = "git";
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git log --oneline --graph";

      # 目录导航
      ".." = "cd ..";
      "..." = "cd ../..";

      # Zoxide 别名
      cd = "z";
    };

    # JetBrains IDE 启动函数（后台运行）
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

    # 插件
    plugins = [
      # z - 智能目录跳转
      {
        name = "z";
        src = pkgs.fetchFromGitHub {
          owner = "jethrokuan";
          repo = "z";
          rev = "85f863f20f24faf675827fb00f3a4e15c7838d76";
          sha256 = "sha256-+FUBM7CodtZrYKqU542fQD+ZDGrd2438trKM0tIESs0=";
        };
      }
      # fzf.fish - 模糊搜索
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
