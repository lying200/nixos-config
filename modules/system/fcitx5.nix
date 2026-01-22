{ pkgs, inputs, ... }:

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

            # 2. 写入默认配置：启用小鹤双拼
            cat > $out/share/rime-data/default.custom.yaml <<EOF
            patch:
              schema_list:
                - schema: double_pinyin_flypy   # 雾凇拼音自带的小鹤方案
                - schema: rime_ice              # 备用
              "menu/page_size": 9
            EOF
          '')
        ];
      })
      qt6Packages.fcitx5-chinese-addons
      fcitx5-gtk
      fcitx5-nord
      fcitx5-material-color
      fcitx5-fluent
    ];
  };

}
