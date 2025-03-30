{ pkgs, ... }: let
  colors = (builtins.fromTOML (builtins.readFile ./dotfiles/alacritty/tokyonight_moon.toml)).colors;
in {

  home.packages = with pkgs; [
    noto-fonts
    noto-fonts-color-emoji
    liberation_ttf
    material-symbols
    powerline-symbols
  ];

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.numix-cursor-theme;
    name = "Numix-Cursor";
    size = 24;
  };

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      sansSerif = [ "Noto Sans" ];
    };
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.tokyonight-gtk-theme.override {
        tweakVariants = [ "moon" ];
        themeVariants = [ "teal" ];
      };
      name = "Tokyonight-Teal-Dark-Moon";
    };

    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };

    font = {
      name = "Noto Sans";
      size = 10;
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
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "";
    };
  };

  qt.platformTheme = "gtk";
  qt.style.name = "breeze";

  programs.alacritty = {
    settings = {
      window = {
        padding = { x = 10; y = 10; };
        opacity = 1.0;
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
      inherit colors;
    };
  };

  programs.helix.settings.theme = "tokyonight_moon";

  programs.waybar.style = ''
    * {
      border: none;
      border-radius: 0;
      color: ${colors.primary.foreground};
      font-family: "Liberation Sans", "Material Symbols Sharp";
      font-weight: 500;
      font-size: 14px;
    }
    window {
      background: ${colors.primary.background};
      padding: 0 2px;
    }
    tooltip {
      background: ${colors.primary.background};
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
      color: inherit;
    }
    #clock {
      margin-right: 4px;
    }
  '';

  services.mako = {
    textColor = "${colors.primary.foreground}";
    borderColor = "${colors.primary.foreground}";
    backgroundColor = "${colors.primary.background}";
    borderSize = 2;
    borderRadius = 4;
    width = 400;
    height = 200;
    padding = "20";
    margin = "20";
  };

  wayland.windowManager.sway = {
    config = {
      colors = rec {
        focused = rec {
          background = "${colors.primary.background}";
          text = "${colors.primary.foreground}";
          border = background;
          childBorder = background;
          indicator = "${colors.primary.foreground}";
        };
        focusedInactive = focused;
        unfocused = focused;
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
    };
    extraConfig = ''
      blur enable
      blur_xray enable
      blur_passes 6
      blur_radius 10
      blur_noise 0.1
      corner_radius 4
      shadows enable
      shadow_color #00000010
      shadow_inactive_color #00000010
      shadow_blur_radius 3
      shadow_offset 0 0
      # titlebar_padding 12 8
    '';
  };

  programs.rofi = {
    theme = ./dotfiles/rofi/tokyonight.rasi;
    extraConfig = {
      show-icons = true;
      drun-display-format = "{icon} {name}";
      location = 0;
      sidebar-mode = true;
    };
  };

}
