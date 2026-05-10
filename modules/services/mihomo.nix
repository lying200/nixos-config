{ config, lib, pkgs, username, ... }:

with lib;

let
  home = config.users.users.${username}.home;
  configDir = "${home}/.config/mihomo";
  configFile = "${configDir}/config.yaml";
in
{
  options.mySystem.services.mihomo = {
    enable = mkEnableOption "Mihomo proxy service";
  };

  config = mkIf config.mySystem.services.mihomo.enable {
    services.mihomo = {
      enable = true;
      package = pkgs.mihomo;
      inherit configFile;

      # The config file still needs `tun.enable: true`; this only grants the
      # systemd service the capabilities required to create and route TUN.
      tunMode = true;
      processesInfo = true;
      webui = pkgs.metacubexd;
    };

    environment.systemPackages = with pkgs; [
      mihomo
      metacubexd
    ];

    # NixOS' nftables firewall/rpfilter can drop traffic from Mihomo's TUN
    # device even when the device is created successfully.
    networking.firewall = {
      checkReversePath = mkDefault "loose";
      trustedInterfaces = mkAfter [ "mihomo" ];
      extraReversePathFilterRules = ''
        iifname { "mihomo" } accept comment "mihomo tun"
      '';
    };

    system.activationScripts.mihomo-config.text = ''
      install -d -m 0700 -o ${username} -g users ${configDir}

      if [ ! -f ${configFile} ]; then
        cat > ${configFile} <<'EOF'
mixed-port: 7890
allow-lan: false
mode: rule
log-level: info
ipv6: false

external-controller: 127.0.0.1:9090
secret: ""

profile:
  store-selected: true
  store-fake-ip: true

tun:
  enable: true
  stack: mixed
  device: mihomo
  auto-route: true
  auto-detect-interface: true
  strict-route: true
  dns-hijack:
    - any:53
  route-exclude-address:
    - 10.0.0.0/8
    - 100.64.0.0/10
    - 172.16.0.0/12
    - 192.168.0.0/16
    - 224.0.0.0/4
    - fd00::/8
    - fe80::/10

dns:
  enable: true
  listen: 127.0.0.1:1053
  ipv6: false
  enhanced-mode: fake-ip
  fake-ip-range: 198.18.0.1/16
  fake-ip-filter:
    - "*.lan"
    - "*.local"
    - "localhost.ptlogin2.qq.com"
  default-nameserver:
    - 223.5.5.5
    - 119.29.29.29
  nameserver:
    - https://dns.alidns.com/dns-query
    - https://doh.pub/dns-query
  fallback:
    - https://1.1.1.1/dns-query
    - https://8.8.8.8/dns-query
  proxy-server-nameserver:
    - https://dns.alidns.com/dns-query
  nameserver-policy:
    "geosite:cn":
      - https://dns.alidns.com/dns-query

# Put provider subscriptions here. Keep subscription URLs out of the Nix repo.
# Example:
# proxy-providers:
#   main:
#     type: http
#     url: "https://example.com/subscription.yaml"
#     interval: 3600
#     path: ./providers/main.yaml
#     health-check:
#       enable: true
#       interval: 600
#       url: https://www.gstatic.com/generate_204

proxy-groups:
  - name: PROXY
    type: select
    proxies:
      - DIRECT
    # use:
    #   - main
    # For subscriptions, a convenient shape is:
    # proxies:
    #   - AUTO
    #   - DIRECT
    # use:
    #   - main
  # - name: AUTO
  #   type: url-test
  #   use:
  #     - main
  #   url: https://www.gstatic.com/generate_204
  #   interval: 300
  #   tolerance: 50

rules:
  - IP-CIDR,127.0.0.0/8,DIRECT,no-resolve
  - IP-CIDR,10.0.0.0/8,DIRECT,no-resolve
  - IP-CIDR,100.64.0.0/10,DIRECT,no-resolve
  - IP-CIDR,172.16.0.0/12,DIRECT,no-resolve
  - IP-CIDR,192.168.0.0/16,DIRECT,no-resolve
  - GEOSITE,cn,DIRECT
  - GEOIP,cn,DIRECT
  - MATCH,PROXY
EOF
        chown ${username}:users ${configFile}
        chmod 0600 ${configFile}
      fi
    '';
  };
}
