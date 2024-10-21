{ config, lib, pkgs, ... }: {

  imports = [ ./home.nix ];

  home.packages = with pkgs; [
    noto-fonts
    noto-fonts-color-emoji
    material-symbols
    powerline-symbols
    socat
    jq
    brightnessctl
    pamixer
    pavucontrol
    simple-scan
    gimp
    mpv
    blender
    audacity
    wireshark
  ];

  programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium;
    commandLineArgs = [
      "--enable-features=VaapiVideoDecodeLinuxGL,VaapiVideoDecoder,VaapiVideoEncoder" "--disable-features=UseChromeOSDirectVideoDecoder" "--ozone-platform=wayland"
    ];
  };

  home.sessionVariables = {
    VK_DRIVER_FILES = "/run/opengl-driver/share/vulkan/icd.d/intel_icd.x86_64.json";
  };

  programs.helix.settings.theme = "dracula";

  programs.alacritty = {
    enable = true;
    settings = {
      shell = "${pkgs.nushell}/bin/nu";
      window = {
        padding = { x = 3; y = 3; };
        opacity = 0.95;
      };
      font = {
        normal = {
          family = "Noto Sans Mono";
          style = "Regular";
        };
        size = 10;
      };
      colors = {
        primary = {
          background = "#282a36";
          foreground = "#f8f8f2";
        };
        normal = {
          black = "#000000";
          red = "#ff5555";
          green = "#50fa7b";
          yellow = "#f1fa8c";
          blue = "#bd93f9";
          magenta = "#ff79c6";
          cyan = "#8be9fd";
          white = "#bbbbbb";
        };
        bright = {
          black = "#555555";
          red = "#ff5555";
          green = "#50fa7b";
          yellow = "#f1fa8c";
          blue = "#caa9fa";
          magenta = "#ff79c6";
          cyan = "#8be9fd";
          white = "#ffffff";
        };
      };
    };
  };

  programs.waybar = {
    enable = true;
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
              months = "<span color='#ffead3'><b>{}</b></span>";
              days = "<span color='#ecc6d9'><b>{}</b></span>";
              weeks = "<span color='#99ffdd'><b>W{}</b></span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              today = "<span color='#ff6699'><b><u>{}</u></b></span>";
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
    style = ''
      * {
        border: none;
        border-radius: 0;
        color: white;
        font-family: "Noto Sans", "Material Symbols Sharp";
        font-weight: 500;
        font-size: 14px;
      }
      window {
        background: #222;
        padding: 0 2px;
      }
      tooltip {
        background: #222;
        border-radius: 6px;
      }
      box > * > * {
        padding: 0 4px;
      }
      #workspaces {
        padding: 0;
      }
      #workspaces button {
        padding: 0 4px;
        color: white;
      }
      #clock {
        margin-right: 4px;
      }
    '';
  };

  wayland.windowManager.sway = {
    enable = true;
    systemd.enable = true;
    package = pkgs.swayfx;
    checkConfig = false; # Breaks with swayfx
    config = rec {
      modifier = "Mod4";
      window = {
        titlebar = true;
        hideEdgeBorders = "smart";
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
        ];
      };
      colors = {
        focused = {
          background = "#1b1d21";
          childBorder = "#252b38";
          border = "#252b38";
          indicator = "#363e44";
          text = "#ffffff";
        };
        unfocused = {
          background = "#222428";
          childBorder = "#212733";
          border = "#212733";
          indicator = "#2d343a";
          text = "#777777";
        };
      };
      gaps = {
        smartBorders = "on";
      };
      fonts = {
        names = [ "Noto Sans" ];
        style = "Regular";
        size = 10.0;
      };
      bars = [];
      menu = "${config.programs.rofi.package}/bin/rofi -show drun";
      terminal = "${pkgs.alacritty}/bin/alacritty";
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
        "LG Electronics LG FULL HD 0x00069969" = {
          mode = "1920x1080@60.0Hz";
          pos = "0 0";
          subpixel = "rgb";
          # color_profile = "icc ${../../modules/hardware/display/LG-22MN430M/LG-22MN430M.icc}";
        };
        "LG Display 0x0719 0x090003A1" = {
          mode = "2880x1920@60Hz";
          pos = "1920 0";
          subpixel = "none";
          adaptive_sync = "on";
        };
      };
    };
    extraConfig = ''
      blur enable
      blur_xray enable
      blur_passes 2
      blur_radius 10
      blur_noise 0.2
      blur_brightness 0.9
      corner_radius 6
      shadows enable
      shadow_color #000000d0
      shadow_inactive_color #000000a0
      shadow_blur_radius 24
      shadow_offset 0 0
    '';
  };

  programs.bash.enable = true;
  programs.bash.bashrcExtra = ''
    if [ "$(tty)" = "/dev/tty1" ]; then
      systemctl --user import-environment PATH TERM EDITOR GTK_PATH VDPAU_DRIVER XCURSOR_PATH XDG_CONFIG_DIRS XDG_DATA_DIRS
      exec ${pkgs.systemd}/bin/systemctl --wait --user start sway
      exit 1
    fi
  '';

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    theme = "${pkgs.rofi}/share/rofi/themes/Monokai.rasi";
  };

  services.mako = {
    enable = true;
    textColor = "#ffffff";
    borderColor = "#446270";
    backgroundColor = "#292E2E";
    borderSize = 1;
    borderRadius = 3;
    width = 400;
    height = 200;
    padding = "20";
    margin = "20";
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

  services.swayidle = {
    enable = true;
    events = [{
      event = "before-sleep";
      command = "${config.programs.swaylock.package}/bin/swaylock -fF";
    }];
    timeouts = [{
      timeout = 300;
      command = "${config.programs.swaylock.package}/bin/swaylock -fF";
    } {
      timeout = 360;
      command = "${pkgs.systemd}/bin/systemctl suspend";
    }];
  };

  systemd.user.services."swayidle" = {
    Unit = {
      BindsTo = "sway-session.target";
    };
    Service = {
      Type = "simple";
    };
    Install = {
      RequiredBy = [ "sway-session.target" ];
    };
  };

  systemd.user.services."sway" = {
    Service = {
      Type = "simple";
      ExecStart = "${config.wayland.windowManager.sway.package}/bin/sway";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
      Environment = [
        "PATH=/run/wrappers/bin:/run/current-system/sw/bin:${config.home.profileDirectory}/bin"
        "WLR_BACKENDS=drm,libinput"
        "WLR_RENDERER=vulkan"
      ];
    };
  };

  systemd.user.services."waybar" = {
    Service = {
      Type = "simple";
      ExecStart = "${config.programs.waybar.package}/bin/waybar";
      Environment = [
        "PATH=${pkgs.runtimeShell}/bin"
      ];
    };
    Install = {
      WantedBy = [ "sway-session.target" ];
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.numix-cursor-theme;
    name = "Numix-Cursor";
    size = 24;
  };

  fonts.fontconfig.enable = true;

  gtk = {
    enable = true;
    theme = {
      package = pkgs.libsForQt5.breeze-gtk;
      name = "Breeze";
    };

    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };

    font = {
      name = "Sans";
      size = 11;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  qt.platformTheme = "gtk";

  services.mpd.enable = true;
  xdg.userDirs.enable = true;

}
