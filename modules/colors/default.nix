{ lib, ... }:
let
  themeFile = ./tokyonight_moon.toml;

  colors = (builtins.fromTOML (builtins.readFile themeFile)).colors;

  formatTermux = colors: lib.mapAttrs (_: hex: "#${builtins.substring 1 7 hex}") (with colors; {
    foreground = primary.foreground;
    background = primary.background;
    color0 = normal.black;
    color1 = normal.red;
    color2 = normal.green;
    color3 = normal.yellow;
    color4 = normal.blue;
    color5 = normal.magenta;
    color6 = normal.cyan;
    color7 = normal.white;
    color8 = bright.black;
    color9 = bright.red;
    color10 = bright.green;
    color11 = bright.yellow;
    color12 = bright.blue;
    color13 = bright.magenta;
    color14 = bright.cyan;
    color15 = bright.white;
  });

  formatFoot = colors: lib.mapAttrs (_: hex: builtins.substring 1 7 hex) (with colors; {
    foreground = primary.foreground;
    background = primary.background;
    regular0 = normal.black;
    regular1 = normal.red;
    regular2 = normal.green;
    regular3 = normal.yellow;
    regular4 = normal.blue;
    regular5 = normal.magenta;
    regular6 = normal.cyan;
    regular7 = normal.white;
    bright0 = bright.black;
    bright1 = bright.red;
    bright2 = bright.green;
    bright3 = bright.yellow;
    bright4 = bright.blue;
    bright5 = bright.magenta;
    bright6 = bright.cyan;
    bright7 = bright.white;
  });
in {

  alacritty = colors;

  termux = formatTermux colors;

  foot = formatFoot colors;

}
