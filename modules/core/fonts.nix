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
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      noto-fonts-emoji-blob-bin
    ];

    fontconfig.defaultFonts = {
      monospace = [
        "JetBrainsMono Nerd Font"
        "Cascadia Code"
        "Sarasa Mono SC"
      ];

      sansSerif = [
        "LXGW WenKai"
        "Sarasa UI SC"
        "Noto Sans CJK SC"
      ];

      serif = [
        "LXGW WenKai"
        "Noto Serif CJK SC"
      ];

      emoji = [
        "Noto Color Emoji"
      ];
    };
  };
}
