{ config, lib, pkgs, username, ... }:

with lib;

{
  options.mySystem.services.k3s = {
    enable = mkEnableOption "K3s lightweight Kubernetes";
  };

  config = mkIf config.mySystem.services.k3s.enable {
    services.k3s = {
      enable = true;
      role = "server";
    };

    networking.firewall.allowedTCPPorts = [ 6443 ];

    environment.systemPackages = with pkgs; [
      kubectl
      kubernetes-helm
      k9s
    ];

    # 自动同步 k3s kubeconfig 到用户目录，使 kubectl 直接可用
    system.activationScripts.k3s-kubeconfig.text = let
      home = config.users.users.${username}.home;
    in ''
      if [ -f /etc/rancher/k3s/k3s.yaml ]; then
        mkdir -p ${home}/.kube
        cp /etc/rancher/k3s/k3s.yaml ${home}/.kube/config
        chown ${username}:users ${home}/.kube/config
        chmod 600 ${home}/.kube/config
      fi
    '';
  };
}
