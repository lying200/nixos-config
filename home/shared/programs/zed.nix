{ pkgs, lib, ... }:

{
  programs.zed-editor = {
    enable = true;
    
    # 推荐扩展
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
      
      # 主题设置（跟随系统）
      theme = {
        mode = "system";
        dark = "One Dark";
        light = "One Light";
      };
      
      # 24小时制
      hour_format = "hour24";
      
      vim_mode = true;
      
      # 显示空白字符
      show_whitespaces = "selection";
      
      # 字体大小
      ui_font_size = 16;
      buffer_font_size = 16;
      
      # 终端配置
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
      
      # LSP 配置 - 使用 PATH 中的 LSP 服务器
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
      
      # 语言特定配置
      languages = {
        "Nix" = {
          tab_size = 2;
        };
      };
    };
    
    # 安装远程服务器支持（用于远程协作）
    installRemoteServer = true;
  };
  
  # 全局安装常用 LSP 服务器
  home.packages = with pkgs; [
    # Nix LSP
    nil
    nixd
    
    # Rust LSP
    rust-analyzer
    
    # Go LSP
    gopls
    
    # 其他工具
    shellcheck  # Shell 脚本检查
  ];
}
