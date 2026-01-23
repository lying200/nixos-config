{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # IntelliJ IDEA Ultimate with Wayland support (使用 unstable 保持最新)
    (jetbrains.idea.override {
      vmopts = ''
        -Dawt.toolkit.name=WLToolkit
      '';
    })
    vscode
    wechat
    google-chrome
    gemini-cli

    ulauncher
    wmctrl
  ];

  # IntelliJ IDEA Wayland 支持配置
  environment.sessionVariables = {
    _JAVA_AWT_WM_NONREPARENTING = "1";  # 修复 tiling WM 问题
  };
}
