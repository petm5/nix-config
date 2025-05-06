{

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "bottom";
        height = 26;
        modules-left = [ "wlr/workspaces" ];
        modules-right = [ "wireplumber" "mpd" "battery" "clock" ];
        battery = {
          interval = 2;
          format = "{icon}";
          format-icons = {
            unknown = [ "" ];
            charging = [ "" "" "" "" "" "" "" ];
            full = [ "" ];
            discharging = [ "" "" "" "" "" "" "" ];
            plugged = [ "" "" "" "" "" "" "" ];
          };
        };
        mpd = {
          format = "{stateIcon}";
          format-stopped = "";
          state-icons = {
            paused = "";
            playing = "";
          };
        };
        wireplumber = {
          format = "{icon}";
          format-icons = [ "" "" "" ];
          format-muted = "";
        };
        clock = {
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "right";
            format = {
              months = "<span color='#fe640b'><b>{}</b></span>";
              days = "<span color='#6c6f85'><b>{}</b></span>";
              weeks = "<span color='#179299'><b>W{}</b></span>";
              weekdays = "<span color='#df8e1d'><b>{}</b></span>";
              today = "<span color='#1e66f5'><b><u>{}</u></b></span>";
            };
          };
        };
        "wlr/workspaces" = {
          format = "{icon}";
          format-icons = {
            "1" = "";
            "2" = "";
            "3" = "";
            "4" = "";
          };
          persistent-workspaces = {
            "1" = [];
            "2" = [];
            "3" = [];
            "4" = [];
          };
        };
      };
    };
  };

}
