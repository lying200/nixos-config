{ pkgs, inputs, ... }:

{
  # 导入 Noctalia Home Manager 模块
  imports = [
    inputs.noctalia.homeModules.default
  ];

  # Noctalia Shell 配置
  programs.noctalia-shell = {
    enable = true;

    settings = builtins.fromJSON (builtins.readFile ./noctalia-settings.json);
  };

  # Noctalia 运行时依赖
  home.packages = with pkgs; [
    brightnessctl     # 亮度控制（Noctalia 必需）
    imagemagick       # 模板处理和壁纸缩放（Noctalia 必需）
    python3           # 模板处理（Noctalia 必需）
    git               # 插件系统（Noctalia 必需）
    cliphist          # 剪贴板历史
    wlsunset          # 夜间模式
  ];
}
