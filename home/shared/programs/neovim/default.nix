{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withRuby = false;
    withPython3 = false;

    extraPackages = with pkgs; [
      # 剪贴板
      wl-clipboard
      xclip

      # Treesitter 编译依赖
      gcc
      gnumake

      # LazyVim 依赖
      git
      lazygit
      ripgrep
      fd

      # LSP 常用语言服务器
      lua-language-server
      nil # Nix LSP
      typescript-language-server
      vscode-langservers-extracted # HTML/CSS/JSON/ESLint
      yaml-language-server
      bash-language-server
      pyright
    ];
  };

  # recursive = true 强制 home-manager 逐文件 symlink 而非合并成目录链接
  # 这样 ~/.config/nvim/ 本身是真实目录，lazy.nvim 可以写入 lazy-lock.json
  xdg.configFile."nvim" = {
    source = ./nvim;
    recursive = true;
  };
}
