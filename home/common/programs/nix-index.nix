{pkgs, ...}: {
  systemd.user.services.nix-index-update = {
    Unit.Description = "Update the nix-index database for comma";
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.nix-index}/bin/nix-index";
    };
  };

  systemd.user.timers.nix-index-update = {
    Unit.Description = "Update the nix-index database weekly";
    Timer = {
      OnBootSec = "10m";
      OnUnitActiveSec = "7d";
      Persistent = true;
    };
    Install.WantedBy = ["timers.target"];
  };
}
