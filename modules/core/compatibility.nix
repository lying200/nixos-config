{ pkgs, ... }:

{
  # 兼容性配置：修复非 NixOS 软件的常见问题

  # 创建 /bin/bash 软链接
  system.activationScripts.binbash = {
    text = ''
      mkdir -p /bin
      ln -sf ${pkgs.bash}/bin/bash /bin/bash
    '';
  };
}
