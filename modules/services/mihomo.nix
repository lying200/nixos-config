{ config, lib, pkgs, username, ... }:

let
  home = config.users.users.${username}.home;
  configDir = "${home}/.config/mihomo";
  configFile = "${configDir}/config.yaml";
in
{
  options.mySystem.services.mihomo = {
    enable = lib.mkEnableOption "Mihomo proxy service";
  };

  config = lib.mkIf config.mySystem.services.mihomo.enable {
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

    # NixOS' nftables firewall/rpfilter can drop traffic from Mihomo's TUN
    # device even when the device is created successfully.
    networking.firewall = {
      checkReversePath = lib.mkDefault "loose";
      trustedInterfaces = lib.mkAfter [ "mihomo" ];
      extraReversePathFilterRules = ''
        iifname { "mihomo" } accept comment "mihomo tun"
      '';
    };

    # 首次部署时写入默认配置模板（mihomo-config.yaml），已存在则不覆盖
    system.activationScripts.mihomo-config.text = ''
      install -d -m 0700 -o ${username} -g users ${configDir}

      if [ ! -f ${configFile} ]; then
        cat > ${configFile} <<'EOF'
${builtins.readFile ./mihomo-config.yaml}EOF
        chown ${username}:users ${configFile}
        chmod 0600 ${configFile}
      fi
    '';
  };
}
