{ pkgs, inputs, lib, ... }:

{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      (fcitx5-rime.override {
        rimeDataPkgs = [
          (pkgs.runCommand "rime-ice" {} ''
            # 1. 拷贝雾凇拼音所有文件
            mkdir -p $out/share/rime-data
            cp -r ${inputs.rime-ice}/* $out/share/rime-data/

            # 2. 写入默认配置：启用小鹤双拼和自定义快捷键
            cat > $out/share/rime-data/default.custom.yaml <<'EOF'
patch:
  schema_list:
    - schema: double_pinyin_flypy   # 雾凇拼音自带的小鹤方案
    - schema: rime_ice              # 备用
  "menu/page_size": 9
  "switcher/hotkeys":
    - "Control+Shift+F4"
EOF
          '')
        ];
      })
      qt6Packages.fcitx5-chinese-addons
      fcitx5-gtk
      fcitx5-nord
      fcitx5-material-color
      fcitx5-fluent
      fcitx5-mellow-themes
      gnomeExtensions.kimpanel
      qt6Packages.fcitx5-configtool
    ];
  };

  services.desktopManager.gnome.extraGSettingsOverrides = ''
    [org.gnome.settings-daemon.plugins.xsettings]
    overrides={'Gtk/IMModule': <'fcitx'>}
  '';

  # Wayland 下 GTK_IM_MODULE 应为空字符串
  # 通过 text-input-v3 协议与输入法通信
  environment.variables = {
    GTK_IM_MODULE = lib.mkForce "";
  };

  environment.sessionVariables = {
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    SDL_IM_MODULE = "fcitx";
    GLFW_IM_MODULE = "ibus";    # GLFW 应用（部分 Electron）输入法支持
    INPUT_METHOD = "fcitx";     # 通用输入法标识
  };

}
