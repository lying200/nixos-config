{ pkgs, lib, ... }:

{
  programs.zed-editor = {
    enable = true;

    extensions = [
      "nix"
      "toml"
      "rust"
      "make"
    ];

    userSettings = {
      # 关闭自动更新（由 Nix 管理）
      auto_update = false;

      # 启用 direnv 支持（集成 nix-shell 环境）
      load_direnv = "shell_hook";

      theme = {
        mode = "system";
        dark = "One Dark";
        light = "One Light";
      };

      hour_format = "hour24";

      vim_mode = true;

      show_whitespaces = "selection";

      ui_font_size = 16;
      buffer_font_size = 16;

      terminal = {
        alternate_scroll = "off";
        blinking = "off";
        copy_on_select = false;
        dock = "bottom";
        detect_venv = {
          on = {
            directories = [ ".env" "env" ".venv" "venv" ];
            activate_script = "default";
          };
        };
        line_height = "comfortable";
        working_directory = "current_project_directory";
      };

      # 使用 PATH 中的 LSP 服务器
      lsp = {
        rust-analyzer = {
          binary = {
            path_lookup = true;
          };
        };

        nix = {
          binary = {
            path_lookup = true;
          };
        };

        gopls = {
          binary = {
            path_lookup = true;
          };
        };
      };

      languages = {
        "Nix" = {
          tab_size = 2;
        };
      };
    };

    installRemoteServer = true;
  };

  home.packages = with pkgs; [
    nil
    nixd
    rust-analyzer
    gopls
    shellcheck
  ];
}
