{ pkgs, ... }:

{
  # Direnv - 自动加载项目环境
  # 由 Home Manager 管理，会自动集成到 shell 中
  programs.direnv = {
    enable = true;

    # nix-direnv 集成 - 提升性能，缓存 nix-shell/flake 环境
    nix-direnv.enable = true;

    # 配置
    config = {
      # 全局设置
      global = {
        # 隐藏 direnv 加载信息（可选，保持终端整洁）
        # hide_env_diff = true;
      };
    };
  };

  # 确保 direnv 包在用户环境中可用
  home.packages = with pkgs; [
    direnv
  ];
}
