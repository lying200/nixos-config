{ pkgs, ... }:

{
  fonts = {
    fontDir.enable = true;

    packages = with pkgs; [
      cascadia-code
      jetbrains-mono
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code

      lxgw-wenkai

      sarasa-gothic

      noto-fonts-cjk-sans
      noto-fonts-color-emoji
    ];

    fontconfig.defaultFonts = {
      # 终端/代码编辑器默认字体
      monospace = [
        "Cascadia Code"
        "Sarasa Mono SC"
      ];

      # 系统 UI / 网页默认字体 (无衬线)
      sansSerif = [
        "LXGW WenKai"         # 1. 优先用霞鹜文楷 (非常友好的阅读感)
        "Sarasa UI SC"        # 2. 其次用更纱 UI
        "Noto Sans CJK SC"    # 3. 保底
      ];

      # 文档/衬线字体
      serif = [
        "LXGW WenKai"
        "Noto Serif CJK SC"
      ];
    };
  };
}
