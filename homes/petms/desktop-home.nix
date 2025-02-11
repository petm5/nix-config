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
    file-roller
    unzip
    gnome-font-viewer
    system-config-printer
    dig
    wl-clipboard
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

  programs.helix.settings.theme = "github_light";

  programs.alacritty = {
    enable = true;
    settings = {
      terminal = {
        shell = "${pkgs.nushell}/bin/nu";
      };
      window = {
        padding = { x = 10; y = 10; };
        # opacity = 0.9;
      };
      font = {
        normal = {
          family = "Liberation Mono";
          style = "Regular";
        };
        size = 9;
        offset = {
          x = 0;
          y = 6;
        };
      };
      colors = {
        selection = {
          background = "#d1ecf9";
          foreground = "#202020";
        };
        primary = {
          background = "#ffffff";
          foreground = "#424242";
        };
        normal = {
          black = "#212121";
          red = "#B71C1C";
          green = "#1B5E20";
          yellow = "#827717";
          blue = "#1A237E";
          magenta = "#4A148C";
          cyan = "#006064";
          white = "#757575";
        };
        bright = {
          black = "#37474F";
          red = "#D32F2F";
          green = "#43A047";
          yellow = "#FDD835";
          blue = "#1E88E5";
          magenta = "#7B1FA2";
          cyan = "#00695C";
          white = "#9E9E9E";
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
    style = ''
      * {
        border: none;
        border-radius: 0;
        color: #4c4f69;
        font-family: "Liberation Sans", "Material Symbols Sharp";
        font-weight: 500;
        font-size: 14px;
      }
      window {
        background: #eff1f5;
        padding: 0 2px;
      }
      tooltip {
        background: #e6e9ef;
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
        color: #5c5f77;
      }
      #clock {
        margin-right: 4px;
      }
    '';
  };

  wayland.windowManager.sway = {
    enable = true;
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
      colors = {
        focused = rec {
          background = "#dee4f9";
          text = "#282828";
          border = background;
          childBorder = background;
          indicator = "#d1d1d1";
        };
        focusedInactive = rec {
          background = "#eaebef";
          text = "#282828";
          border = background;
          childBorder = background;
          indicator = "#d1d1d1";
        };
        unfocused = rec {
          background = "#eaebef";
          text = "#282828";
          border = background;
          childBorder = background;
          indicator = "#d1d1d1";
        };
      };
      gaps = {
        inner = 24;
        outer = 0;
      };
      fonts = {
        names = [ "Liberation Sans" ];
        style = "";
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
        "Samsung Electric Company S22R35x 0x43574250" = {
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
          color_profile = "icc ${../../modules/hardware/surface-pro-9-intel/LP129WT2_SPA6_calibrated.icm}";
        };
      };
    };
    # extraConfig = ''
    #   blur enable
    #   blur_xray enable
    #   blur_passes 6
    #   blur_radius 10
    #   blur_noise 0.1
    #   corner_radius 8
    #   shadows enable
    #   shadow_color #00000030
    #   shadow_inactive_color #00000020
    #   shadow_blur_radius 24
    #   shadow_offset 0 0
    #   titlebar_padding 12 8
    #   default_border pixel 2
    # '';
  };

  programs.bash.enable = true;
  programs.bash.bashrcExtra = ''
    if uwsm check may-start; then
      exec uwsm start sway-uwsm.desktop
      exit 0
    fi
  '';

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    theme = ./dotfiles/rofi/catppuccin-latte.rasi;
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
    textColor = "#282828";
    borderColor = "#eaebef";
    backgroundColor = "#ffffff";
    borderSize = 2;
    borderRadius = 4;
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
      name = "Breeze";
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
      color-scheme = "prefer-light";
    };
    "org/gnome/desktop/a11y/applications" = {
      screen-keyboard-enabled = true;
    };
  };

  qt.platformTheme = "gtk";
  qt.style.name = "breeze";

  services.mpd.enable = true;
  xdg.userDirs.enable = true;

  programs.gpg.enable = true;

  services.gpg-agent.enable = true;
  services.gpg-agent.pinentryPackage = pkgs.pinentry-rofi;

  programs.password-store.enable = true;
  programs.password-store.package = pkgs.pass.withExtensions (exts: [ exts.pass-otp ]);

  services.pass-secret-service.enable = true;
  services.pass-secret-service.storePath = "$\{HOME\}/.password-store";

}
