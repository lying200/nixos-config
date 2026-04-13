{ inputs, username, ... }:

{
  imports = [
    inputs.nixos-wsl.nixosModules.wsl
  ];

  wsl = {
    enable = true;
    defaultUser = username;

    # Windows 互操作
    interop = {
      register = true;
      includePath = true;
    };

    # 使用 Windows 代理（如需要可取消注释）
    # wslConf.network.generateResolvConf = false;
  };

  networking.hostName = "wsl";

  networking.hosts = {
    "100.64.0.3" = [ "infra.dev.internal" ];
    "100.64.0.4" = [ "ops.dev.internal" ];
  };

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  system.stateVersion = "25.11";
}
