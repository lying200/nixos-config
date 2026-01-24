{ ... }:

{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;

    settings = {
      # 整体格式
      format = "$all$directory$character";
      add_newline = true;

      # 字符提示符
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
        vimcmd_symbol = "[⎋](bold yellow)";
      };

      # 目录显示
      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
        style = "bold cyan";
        read_only = " 🔒";
      };

      # Git 状态
      git_branch = {
        symbol = " ";
        style = "bold purple";
        format = "on [$symbol$branch(:$remote_branch)]($style) ";
      };

      git_status = {
        style = "bold red";
        ahead = "⇡\${count}";
        behind = "⇣\${count}";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
        conflicted = "🏳";
        untracked = "🤷";
        stashed = "📦";
        modified = "📝";
        staged = "[++($count)](green)";
        renamed = "👅";
        deleted = "🗑";
      };

      # 编程语言图标
      nodejs = {
        symbol = " ";
        format = "via [$symbol($version )]($style)";
      };

      python = {
        symbol = " ";
        format = "via [$symbol$pyenv_prefix($version )(\($virtualenv\) )]($style)";
      };

      rust = {
        symbol = " ";
        format = "via [$symbol($version )]($style)";
      };

      golang = {
        symbol = " ";
        format = "via [$symbol($version )]($style)";
      };

      java = {
        symbol = " ";
        format = "via [$symbol($version )]($style)";
      };

      # Docker
      docker_context = {
        symbol = " ";
        format = "via [$symbol$context]($style) ";
      };

      # 包管理器
      package = {
        symbol = "📦 ";
        format = "is [$symbol$version]($style) ";
      };

      # 命令执行时间
      cmd_duration = {
        min_time = 500;
        format = "took [$duration](bold yellow) ";
      };

      # Nix Shell
      nix_shell = {
        symbol = " ";
        format = "via [$symbol$state( \($name\))]($style) ";
        impure_msg = "[impure](bold red)";
        pure_msg = "[pure](bold green)";
      };

      # 内存使用（默认禁用）
      memory_usage = {
        disabled = true;
        threshold = 75;
        symbol = " ";
        format = "via $symbol[$ram( | $swap)]($style) ";
      };

      # 电池（笔记本用）
      battery = {
        full_symbol = "🔋";
        charging_symbol = "⚡️";
        discharging_symbol = "💀";
        display = [
          {
            threshold = 10;
            style = "bold red";
          }
          {
            threshold = 30;
            style = "bold yellow";
          }
        ];
      };

      # AWS
      aws = {
        symbol = "  ";
        format = "on [$symbol($profile )(\($region\) )]($style)";
      };
    };
  };
}
