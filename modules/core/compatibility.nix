{ pkgs, ... }:

{
  # 创建 /bin/bash 软链接，修复非 NixOS 软件的兼容性问题
  system.activationScripts.binbash = {
    text = ''
      mkdir -p /bin
      ln -sf ${pkgs.bash}/bin/bash /bin/bash
    '';
  };
}
