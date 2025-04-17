{ config, lib, pkgs, ... }: {

  home.packages = with pkgs; [
    socat
    jq
    brightnessctl
    pamixer
    pavucontrol
    simple-scan
    nautilus
    eog
    file-roller
    gnome-font-viewer
    system-config-printer
    wl-clipboard
    sway-contrib.grimshot
  ];

  wayland.windowManager.sway = {
    enable = true;
    package = pkgs.swayfx;
    checkConfig = false;
    config = rec {
      modifier = "Mod4";
      window = {
        titlebar = true;
        commands = [
          {
            command = "title_format \"[XWayland] %title\"";
            criteria = {
              shell = "xwayland";
            };
          }
          {
            command = "border none";
            criteria = {
              app_id = "chromium-browser";
            };
          }
          {
            command = "border none";
            criteria = {
              app_id = "firefox";
            };
          }
          {
            command = "border none";
            criteria = {
              app_id = "org.gnome.Nautilus";
            };
          }
        ];
      };
      bars = [];
      menu = "${pkgs.systemd}/bin/systemd-run --scope --user ${config.programs.rofi.package}/bin/rofi -show drun";
      terminal = "${pkgs.systemd}/bin/systemd-run --scope --user ${pkgs.alacritty}/bin/alacritty";
      keybindings = lib.mkOptionDefault {
        XF86AudioRaiseVolume = "exec wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+";
        XF86AudioLowerVolume = "exec wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%-";
        XF86AudioMute = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        XF86AudioMicMute = "exec wpctl set-source-mute @DEFAULT_AUDIO_SINK@ toggle";
        XF86MonBrightnessUp = "exec brillo -A 2 -u 100000 -q";
        XF86MonBrightnessDown = "exec brillo -U 2 -u 100000 -q";
        XF86AudioPlay = "exec playerctl play-pause";
        XF86AudioNext = "exec playerctl next";
        XF86AudioPrev = "exec playerctl previous";
        Print = "exec grimshot --notify save output";
      };
      input = {
        "type:touchpad" = {
          tap = "enabled";
          natural_scroll = "enabled";
          accel_profile = "adaptive";
          scroll_factor = "0.3";
        };
      };
      output = {
        "*" = {
          bg = "${./wallpaper} fill";
        };
        "Samsung Electric Company S22R35x 0x43574250" = {
          mode = "1920x1080@60.0Hz";
          pos = "0 0";
          subpixel = "rgb";
        };
        "LG Display 0x0719 0x090003A1" = {
          mode = "2880x1920@60Hz";
          pos = "1920 0";
          subpixel = "none";
          adaptive_sync = "on";
          color_profile = "icc ${../../modules/hardware/surface-pro-9-intel/LP129WT2_SPA6_calibrated.icm}";
        };
      };
    };
  };

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "bottom";
        height = 26;
        modules-left = [ "sway/workspaces" ];
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
        "sway/workspaces" = {
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

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    font = "Noto Sans Mono 14";
    extraConfig = {
      modi = "run,drun,window";
      terminal = "${pkgs.alacritty}/bin/alacritty";
      disable-history = false;
    };
  };

  services.gpg-agent.pinentryPackage = pkgs.pinentry-rofi;

  services.mako = {
    enable = true;
    defaultTimeout = 15000;
  };

  programs.swaylock = {
    enable = true;
    settings = {
      show-failed-attempts = true;
      image = "${./wallpaper}";
      scaling = "fill";
      indicator-radius = 100;
      indicator-idle-visible = false;
    };
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "${config.programs.swaylock.package}/bin/swaylock -fF";
        before_sleep_cmd = "${pkgs.systemd}/bin/loginctl lock-session";
        after_sleep_cmd = "${pkgs.systemd}/bin/loginctl unlock-session";
      };
      listener = [
        {
          timeout = 300;
          on-timeout = "${pkgs.systemd}/bin/loginctl lock-session";
        }
        {
          timeout = 600;
          on-timeout = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ];
    };
  };

  programs.bash.enable = true;
  programs.bash.bashrcExtra = ''
    if uwsm check may-start; then
      exec uwsm start sway-uwsm.desktop >/dev/null
      exit 0
    fi
  '';

}
