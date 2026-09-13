_: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "oracle" = {
        HostName = "144.24.39.57";
        User = "ubuntu";
        IdentityFile = "~/.ssh/id_ed25519";
        IdentitiesOnly = true;
      };

      "rainyun" = {
        HostName = "38.22.90.105";
        User = "root";
        IdentityFile = "~/.ssh/id_ed25519";
        IdentitiesOnly = true;
      };

      "github.com" = {
        HostName = "ssh.github.com";
        Port = 443;
        User = "git";
      };

      "*" = {
        ForwardAgent = false;
        AddKeysToAgent = "no";
        Compression = false;
        ServerAliveInterval = 0;
        ServerAliveCountMax = 3;
        HashKnownHosts = false;
        UserKnownHostsFile = "~/.ssh/known_hosts";
        ControlMaster = "no";
        ControlPath = "~/.ssh/master-%r@%n:%p";
        ControlPersist = "no";
      };
    };
  };
}
