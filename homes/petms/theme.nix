{ pkgs, ... }: {

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
      package = pkgs.kdePackages.breeze-gtk;
      name = "Breeze";
    };

    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus";
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
      color-scheme = "prefer-light";
    };
    "org/gnome/desktop/a11y/applications" = {
      screen-keyboard-enabled = true;
    };
  };

  qt.platformTheme = "gtk";
  qt.style.name = "breeze";

  programs.alacritty = {
    settings = {
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

  programs.helix.settings.theme = "github_light";

  programs.waybar.style = ''
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

  services.mako = {
    textColor = "#282828";
    borderColor = "#eaebef";
    backgroundColor = "#ffffff";
    borderSize = 2;
    borderRadius = 4;
    width = 400;
    height = 200;
    padding = "20";
    margin = "20";
  };

  wayland.windowManager.sway = {
    config = {
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
    };
    extraConfig = ''
      blur enable
      blur_xray enable
      blur_passes 6
      blur_radius 10
      blur_noise 0.1
      corner_radius 4
      shadows enable
      shadow_color #00000030
      shadow_inactive_color #00000020
      shadow_blur_radius 24
      shadow_offset 0 0
      # titlebar_padding 12 8
    '';
  };

  programs.rofi = {
    theme = ./dotfiles/rofi/catppuccin-latte.rasi;
    extraConfig = {
      show-icons = true;
      drun-display-format = "{icon} {name}";
      location = 0;
      hide-scrollbar = true;
      display-drun = " Apps ";
      display-run = " Run ";
      display-window = " Window ";
      display-Network = " Network ";
      sidebar-mode = true;
    };
  };

}
