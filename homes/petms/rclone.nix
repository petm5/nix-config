{ pkgs, ... }: {

  systemd.user.timers."rclone" = {
    Unit = {
      Description = "RClone Sync Timer";
    };
    Timer = {
      Unit = "rclone.service";
      OnBootSec = "2m";
      OnUnitInactiveSec = "2m";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  systemd.user.paths."rclone" = {
    Path = {
      PathChanged = "%h/gdrive/keepassxc";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  systemd.user.services."rclone" = {
    Unit = {
      Description = "RClone Sync";
    };
    Service = {
      ExecStart = "${pkgs.rclone}/bin/rclone bisync \"gdrive:/keepassxc\" \"gdrive/keepassxc\" --force --conflict-resolve path2 --conflict-loser num --resilient --inplace --quiet";
      Restart = "on-failure";
    };
  };

}
