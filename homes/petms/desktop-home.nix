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
        position = "top";
        height = 26;
        modules-left = [ "sway/workspaces" ];
        modules-center = [ "sway/window" ];
        modules-right = [ "wireplumber" "mpd" "battery" "clock" ];
        battery = {
          interval = 2;
          format = "{icon}";
          format-icons = {
            unknown = [ "" ];
            plugged = [ "" "" "" "" "" "" "" ];
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
      };
    };
    style = ''
      * {
        border: none;
        border-radius: 0;
        color: white;
        font-family: "Noto Sans", "Material Symbols Sharp";
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
    package = pkgs.sway_edge;
    config = rec {
      modifier = "Mod4";
      window = {
        titlebar = false;
        hideEdgeBorders = "smart";
      };
      gaps = {
        smartBorders = "on";
      };
      startup = [
        { command = "${pkgs.waybar}/bin/waybar"; always = true; }
      ];
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
  };

  programs.bash.enable = true;
  programs.bash.bashrcExtra = ''
    export WLR_RENDERER=vulkan
    if [ "$(tty)" = "/dev/tty1" ]; then
      exec ${config.wayland.windowManager.sway.package}/bin/sway > /dev/null
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
    package = pkgs.swaylock-effects;
    settings = {
      show-failed-attempts = true;
      grace = 2;
      fade-in = 0.4;
      screenshots = true;
      effect-blur = "128x3";
      effect-vignette = "0.9:0.1";
      no-unlock-indicator = true;
    };
  };

  services.swayidle = {
    enable = true;
    events = [{
      event = "before-sleep";
      command = "${config.programs.swaylock.package}/bin/swaylock -fF --fade-in 0 --grace 0";
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
    Install = {
      RequiredBy = [ "graphical-session.target" ];
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
      color-scheme = "prefer-light";
    };
  };

  qt.platformTheme = "gtk";

  services.mpd.enable = true;
  xdg.userDirs.enable = true;

}
