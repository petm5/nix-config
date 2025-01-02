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
    nautilus
    eog
    libreoffice
    kdePackages.ark
    unzip
    gnome-font-viewer
    system-config-printer
  ];

  programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium;
    commandLineArgs = [
      "--enable-features=VaapiVideoDecodeLinuxGL,VaapiVideoDecoder,VaapiVideoEncoder" "--disable-features=UseChromeOSDirectVideoDecoder" "--ozone-platform=wayland"
    ];
  };

  programs.firefox = {
    enable = true;
    policies = {
      SearchEngines.Default = "DuckDuckGo";
      DisableTelemetry = true;
      DisableFirefoxAccounts = true;
      DisablePocket = true;
      FirefoxSuggest = {
        WebSuggestions = false;
        SponsoredSuggestions = false;
        ImproveSuggest = false;
        Locked = true;
      };
      DisableFirefoxStudies = true;
      DisableProfileRefresh = true;
      DontCheckDefaultBrowser = true;
      HttpsOnlyMode = "force_enabled";
      DisableSecurityBypass = {
        InvalidCertificate = true;
      };
      Cookies = {
        Behavior = "reject-tracker-and-partition-foreign";
      };
      DisabledCiphers = {
        TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 = true;
        TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256 = true;
        TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA = true;
        TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA = true;
        TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA = true;
        TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA = true;
        TLS_DHE_RSA_WITH_AES_128_CBC_SHA = true;
        TLS_DHE_RSA_WITH_AES_256_CBC_SHA = true;
        TLS_RSA_WITH_AES_128_GCM_SHA256 = true;
        TLS_RSA_WITH_AES_256_GCM_SHA384 = true;
        TLS_RSA_WITH_AES_128_CBC_SHA = true;
        TLS_RSA_WITH_AES_256_CBC_SHA = true;
        TLS_RSA_WITH_3DES_EDE_CBC_SHA = true;
      };
      DisableFeedbackCommands = true;
      DisableSetDesktopBackground = true;
      DNSOverHTTPS = {
          Enabled = true;
          ProviderURL = "https://cloudflare-dns.com/dns-query";
          Locked = true;
      };
      NoDefaultBookmarks = true;
      Extensions = {
        Install = [ "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi" ];
      };
      Preferences = {
        "gfx.webrender.precache-shaders" = true;
        "gfx.canvas.accelerated.cache-items" = 4096;
        "gfx.canvas.accelerated.cache-size" = 512;
        "gfx.content.skia-font-cache-size" = 20;
        "browser.cache.jsbc_compression_level" = 3;
        "media.memory_cache_max_size" = 65536;
        "network.http.max-connections" = 1800;
        "network.ssl_tokens_cache_capacity" = 10240;
        "browser.contentblocking.category" = "strict";
        "browser.uitour.enabled" = false;
        "privacy.globalprivacycontrol.enabled" = true;
        "security.OCSP.enabled" = false;
        "security.ssl.treat_unsafe_negotiation_as_broken" = true;
        "security.tls.enable_0rtt_data" = false;
        "browser.urlbar.trimHttps" = true;
        "browser.urlbar.untrimOnUserInteraction.featureGate" = true;
        "security.insecure_connection_text.enabled" = true;
        "security.insecure_connection_text.pbmode.enabled" = true;
        "dom.security.https_only_mode" = true;
        "pdfjs.enableScripting" = false;
        "network.http.referer.XOriginTrimmingPolicy" = 2;
        "browser.safebrowsing.downloads.enabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "toolkit.telemetry.enabled" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;
        "browser.tabs.crashReporting.sendReport" = false;
        "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
        "browser.privatebrowsing.vpnpromourl" = "";
        "extensions.getAddons.showPane" = false;
        "extensions.htmlaboutaddons.recommendations.enabled" = false;
        "browser.discovery.enabled" = false;
        "browser.shell.checkDefaultBrowser" = false;
        "browser.preferences.moreFromMozilla" = false;
        "browser.aboutConfig.showWarning" = false;
        "browser.aboutwelcome.enabled" = false;
        "browser.urlbar.trending.featureGate" = false;
        "browser.search.suggest.enabled" = false;
        "browser.urlbar.quicksuggest.enabled" = false;
        "browser.newtabpage.activity-stream.feeds.topsites" = false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "extensions.pocket.enabled" = false;
        "general.smoothScroll" = true;
      };
    };
  };

  home.sessionVariables = {
    VK_DRIVER_FILES = "/run/opengl-driver/share/vulkan/icd.d/intel_icd.x86_64.json";
  };

  programs.helix.settings.theme = "base16_transparent";

  programs.alacritty = {
    enable = true;
    settings = {
      terminal = {
        shell = "${pkgs.nushell}/bin/nu";
      };
      window = {
        padding = { x = 3; y = 3; };
        opacity = 0.8;
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
          background = "#212733";
          foreground = "#d9d7ce";
        };
        normal = {
          black = "#191e2a";
          red = "#ed8274";
          green = "#a6cc70";
          yellow = "#fad07b";
          blue = "#6dcbfa";
          magenta = "#cfbafa";
          cyan = "#90e1c6";
          white = "#c7c7c7";
        };
        bright = {
          black = "#686868";
          red = "#f28779";
          green = "#bae67e";
          yellow = "#ffd580";
          blue = "#73d0ff";
          magenta = "#d4bfff";
          cyan = "#95e6cb";
          white = "#ffffff";
        };
      };
    };
  };

  programs.eww = {
    enable = true;
    configDir = ./dotfiles/eww;
  };

  # programs.waybar = {
  #   enable = true;
  #   settings = {
  #     mainBar = {
  #       layer = "top";
  #       position = "bottom";
  #       height = 26;
  #       modules-left = [ "sway/workspaces" ];
  #       modules-right = [ "wireplumber" "mpd" "battery" "custom/wvkbd" "clock" ];
  #       battery = {
  #         interval = 2;
  #         format = "{icon}";
  #         format-icons = {
  #           unknown = [ "" ];
  #           charging = [ "" "" "" "" "" "" "" ];
  #           full = [ "" ];
  #           discharging = [ "" "" "" "" "" "" "" ];
  #         };
  #       };
  #       mpd = {
  #         format = "{stateIcon}";
  #         format-stopped = "";
  #         state-icons = {
  #           paused = "";
  #           playing = "";
  #         };
  #       };
  #       wireplumber = {
  #         format = "{icon}";
  #         format-icons = [ "" "" "" ];
  #         format-muted = "";
  #       };
  #       clock = {
  #         tooltip-format = "<tt><small>{calendar}</small></tt>";
  #         calendar = {
  #           mode = "year";
  #           mode-mon-col = 3;
  #           weeks-pos = "right";
  #           format = {
  #             months = "<span color='#ffead3'><b>{}</b></span>";
  #             days = "<span color='#ecc6d9'><b>{}</b></span>";
  #             weeks = "<span color='#99ffdd'><b>W{}</b></span>";
  #             weekdays = "<span color='#ffcc66'><b>{}</b></span>";
  #             today = "<span color='#ff6699'><b><u>{}</u></b></span>";
  #           };
  #         };
  #       };
  #       "sway/workspaces" = {
  #         format = "{icon}";
  #         format-icons = {
  #           "1" = "";
  #           "2" = "";
  #           "3" = "";
  #           "4" = "";
  #         };
  #         persistent-workspaces = {
  #           "1" = [];
  #           "2" = [];
  #           "3" = [];
  #           "4" = [];
  #         };
  #       };
  #       "custom/wvkbd" = {
  #         format = "";
  #         on-click = "pkill -SIGRTMIN wvkbd";
  #       };
  #     };
  #   };
  #   style = ''
  #     * {
  #       border: none;
  #       border-radius: 0;
  #       color: white;
  #       font-family: "Noto Sans", "Material Symbols Sharp";
  #       font-weight: 500;
  #       font-size: 14px;
  #     }
  #     window {
  #       background: #222;
  #       padding: 0 2px;
  #     }
  #     tooltip {
  #       background: #222;
  #       border-radius: 6px;
  #     }
  #     box > * > * {
  #       padding: 0 4px;
  #     }
  #     #workspaces {
  #       padding: 0;
  #     }
  #     #workspaces button {
  #       padding: 0 4px;
  #       color: white;
  #     }
  #     #clock {
  #       margin-right: 4px;
  #     }
  #   '';
  # };

  wayland.windowManager.sway = {
    enable = true;
    systemd.enable = true;
    package = pkgs.swayfx;
    checkConfig = false; # Breaks with swayfx
    config = rec {
      modifier = "Mod4";
      startup = [ {
        command = "${config.programs.eww.package}/bin/eww open bar";
      } ];
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
      colors = {
        focused = {
          background = "#1b1d21";
          childBorder = "#252b38";
          border = "#252b38";
          indicator = "#363e44";
          text = "#ffffff";
        };
        focusedInactive = {
          background = "#1d1f23";
          childBorder = "#212733";
          border = "#212733";
          indicator = "#2d343a";
          text = "#777777";
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
        # smartBorders = "on";
        inner = 24;
        outer = 0;
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
      blur_passes 6
      blur_radius 10
      blur_noise 0.1
      blur_brightness 0.8
      blur_contrast 0.8
      blur_saturation 0.6
      corner_radius 8
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
      systemctl --user import-environment PATH TERM EDITOR GTK_PATH VDPAU_DRIVER XCURSOR_PATH XDG_CONFIG_DIRS XDG_DATA_DIRS GDK_PIXBUF_MODULE_FILE
      exec ${pkgs.systemd}/bin/systemctl --wait --user start sway
      exit 1
    fi
  '';

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    theme = ./dotfiles/rofi/Catppuccin.rasi;
    font = "Noto Sans Mono 14";
    extraConfig = {
      modi = "run,drun,window";
      show-icons = true;
      terminal = "${pkgs.alacritty}/bin/alacritty";
      drun-display-format = "{icon} {name}";
      location = 0;
      disable-history = false;
      hide-scrollbar = true;
      display-drun = " Apps ";
      display-run = " Run ";
      display-window = " Window ";
      display-Network = " Network ";
      sidebar-mode = true;
    };
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

  services.swayidle = {
    enable = true;
    timeouts = [{
      timeout = 360;
      command = "${pkgs.systemd}/bin/systemctl hibernate || ${pkgs.systemd}/bin/systemctl poweroff";
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

  systemd.user.services."eww" = {
    Service = {
      Type = "exec";
      ExecStart = "${config.programs.eww.package}/bin/eww daemon --no-daemonize";
      Environment = [
        "PATH=/run/wrappers/bin:/run/current-system/sw/bin:${pkgs.runtimeShell}/bin"
      ];
    };
    Install = {
      WantedBy = [ "sway-session.target" ];
    };
  };

  systemd.user.services."wvkbd" = let
    wvkbd = pkgs.wvkbd.overrideAttrs (prev: {
      src = pkgs.fetchFromGitHub {
        owner = "petm5";
        repo = "wvkbd";
        rev = "7e868606dcd664856ddbf257d57634cfb151f3a4";
        hash = "sha256-sJWoWKTmZKhtEfOkq+C6uYwzOH269JRwRpIoB+MI2X0=";
      };
    });
  in {
    Service = {
      Type = "simple";
      ExecStart = "${wvkbd}/bin/wvkbd-mobintl -L 240 --fn \"Roboto 20\" --hidden";
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
      package = pkgs.kdePackages.breeze-gtk;
      name = "Breeze-Dark";
    };

    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus";
    };

    font = {
      name = "Noto Sans";
      size = 11;
    };

    gtk3.extraCss = ''
      .titlebar,
      window {
      	border-radius: 0;
      	box-shadow: none;
      }

      decoration {
      	box-shadow: none;
      }

      decoration:backdrop {
      	box-shadow: none;
      }
    '';
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
    "org/gnome/desktop/a11y/applications" = {
      screen-keyboard-enabled = true;
    };
  };

  qt.platformTheme = "gtk";

  services.mpd.enable = true;
  xdg.userDirs.enable = true;

}
