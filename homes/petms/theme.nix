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
    subpixelRendering = "rgb";
    hinting = "slight";
    defaultFonts = {
      serif = [ "DejaVu Serif" ];
      sansSerif = [ "Roboto" ];
      monospace = [ "Cascadia Code" ];
    };
  };

  home.packages = with pkgs; [
    dejavu_fonts
    noto-fonts
    noto-fonts-color-emoji
    roboto
    liberation_ttf
    cascadia-code
    material-symbols
    powerline-symbols
    adwaita-icon-theme
    papirus-icon-theme
    numix-cursor-theme
  ];

  gtk = {
    enable = true;

    iconTheme.name = "Papirus-Dark";

    gtk3.theme.name = "Adwaita-dark";
    gtk2.theme.name = "Adwaita-dark";
    gtk2.theme.package = pkgs.gnome-themes-extra;

    font = {
      name = "Roboto";
      size = 10.5;
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

  programs.foot.settings = {
    main = {
      font = "Cascadia Code:size=10";
      line-height = "13";
      pad = "10x10";
      dpi-aware = "no";
    };
    colors = let
      formatColor = hex: builtins.substring 1 7 hex;
    in {
      foreground = formatColor colors.primary.foreground;
      background = formatColor colors.primary.background;
      regular0 = formatColor colors.normal.black;
      regular1 = formatColor colors.normal.red;
      regular2 = formatColor colors.normal.green;
      regular3 = formatColor colors.normal.yellow;
      regular4 = formatColor colors.normal.blue;
      regular5 = formatColor colors.normal.magenta;
      regular6 = formatColor colors.normal.cyan;
      regular7 = formatColor colors.normal.white;
      bright0 = formatColor colors.bright.black;
      bright1 = formatColor colors.bright.red;
      bright2 = formatColor colors.bright.green;
      bright3 = formatColor colors.bright.yellow;
      bright4 = formatColor colors.bright.blue;
      bright5 = formatColor colors.bright.magenta;
      bright6 = formatColor colors.bright.cyan;
      bright7 = formatColor colors.bright.white;
    };
  };

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
    #workspaces button, #taskbar button {
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
      font = "DejaVu Sans Mono";
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
