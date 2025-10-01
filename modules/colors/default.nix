let
  themeFile = ./tokyonight_moon.toml;

  colors = (builtins.fromTOML (builtins.readFile themeFile)).colors;

  formatTermux = colors: let
    formatColor = hex: "#${builtins.substring 1 7 hex}";
  in {
    foreground = formatColor colors.primary.foreground;
    background = formatColor colors.primary.background;
    color0 = formatColor colors.normal.black;
    color1 = formatColor colors.normal.red;
    color2 = formatColor colors.normal.green;
    color3 = formatColor colors.normal.yellow;
    color4 = formatColor colors.normal.blue;
    color5 = formatColor colors.normal.magenta;
    color6 = formatColor colors.normal.cyan;
    color7 = formatColor colors.normal.white;
    color8 = formatColor colors.bright.black;
    color9 = formatColor colors.bright.red;
    color10 = formatColor colors.bright.green;
    color11 = formatColor colors.bright.yellow;
    color12 = formatColor colors.bright.blue;
    color13 = formatColor colors.bright.magenta;
    color14 = formatColor colors.bright.cyan;
    color15 = formatColor colors.bright.white;
  };

  formatFoot = colors: let
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
in {

  alacritty = colors;

  termux = formatTermux colors;

  foot = formatFoot colors;

}
