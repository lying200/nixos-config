{
  config,
  lib,
  pkgs,
  username,
  ...
}: {
  options.mySystem.services.k3s = {
    enable = lib.mkEnableOption "K3s lightweight Kubernetes";
  };

  config = lib.mkIf config.mySystem.services.k3s.enable {
    services.k3s = {
      enable = true;
      role = "server";
    };

    networking.firewall.allowedTCPPorts = [6443];

    environment.systemPackages = with pkgs; [
      kubectl
      kubernetes-helm
      k9s
    ];

    # 首次部署时同步 k3s kubeconfig 到用户目录，使 kubectl 直接可用
    # 仅在文件不存在时写入，避免覆盖用户手动合并的其他 cluster context
    system.activationScripts.k3s-kubeconfig.text = let
      home = config.users.users.${username}.home;
    in ''
      if [ -f /etc/rancher/k3s/k3s.yaml ] && [ ! -f ${home}/.kube/config ]; then
        mkdir -p ${home}/.kube
        cp /etc/rancher/k3s/k3s.yaml ${home}/.kube/config
        chown ${username}:users ${home}/.kube/config
        chmod 600 ${home}/.kube/config
      fi
    '';
  };
}
