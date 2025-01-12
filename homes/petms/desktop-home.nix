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

  programs.eww = {
    enable = true;
    configDir = ./dotfiles/eww;
  };

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
        };
      };
    };
    extraConfig = ''
      blur enable
      blur_xray enable
      blur_passes 6
      blur_radius 10
      blur_noise 0.1
      corner_radius 8
      shadows enable
      shadow_color #00000030
      shadow_inactive_color #00000020
      shadow_blur_radius 24
      shadow_offset 0 0
      titlebar_padding 12 8
      default_border pixel 2
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
        "PATH=/run/wrappers/bin:/run/current-system/sw/bin:${pkgs.runtimeShell}/bin:${config.programs.eww.package}/bin:${config.programs.rofi.package}/bin"
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

}
