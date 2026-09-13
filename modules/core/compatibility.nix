{pkgs, ...}: {
  # 创建 /bin/bash 软链接，修复非 NixOS 软件的兼容性问题
  system.activationScripts.binbash = {
    text = ''
      mkdir -p /bin
      ln -sf ${pkgs.bash}/bin/bash /bin/bash
    '';
  };

  # 为使用固定 Bash 路径的第三方工具提供兼容入口。
  systemd.tmpfiles.rules = [
    "L+ /usr/bin/bash - - - - /bin/bash"
  ];

  # 将 ~/.local/bin 添加到 PATH
  environment.localBinInPath = true;
}
