{ pkgs, ... }: let
  colors = (builtins.fromTOML (builtins.readFile ./dotfiles/alacritty/tokyonight_moon.toml)).colors;
in {

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

    iconTheme.name = "Papirus-Dark";

    font = {
      name = "Noto Sans";
      size = 10;
    };

    gtk3.extraCss = ''
      window, .titlebar, headerbar, decoration {
      	border-radius: 0;
      	box-shadow: none;
      }
    '';
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      accent-color = "teal";
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
        decorations = "None";
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

  services.mako.settings = {
    text-color = "${colors.primary.foreground}";
    border-color = "${colors.primary.foreground}";
    background-color = "${colors.primary.background}";
    border-size = 2;
    border-radius = 4;
    width = 400;
    height = 200;
    padding = "20";
    margin = "20";
  };

  programs.fuzzel.settings = {
    main = {
      icon-theme = "Papirus-Dark";
    };
    # fuzzel colors from catppuccin-macchiato/lavender.ini
    colors = {
      background = "24273aff";
      text = "cad3f5ff";
      prompt = "b8c0e0ff";
      placeholder = "8087a2ff";
      input = "cad3f5ff";
      match = "b7bdf8ff";
      selection = "5b6078ff";
      selection-text = "cad3f5ff";
      selection-match = "b7bdf8ff";
      counter = "8087a2ff";
      border = "b7bdf8ff";
    };
  };

}
