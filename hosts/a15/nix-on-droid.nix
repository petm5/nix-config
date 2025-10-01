{ pkgs, ... }: {

  system.stateVersion = "24.05";

  user.shell = "${pkgs.nushell}/bin/nu";

  terminal.font = "${pkgs.cascadia-code}/share/fonts/truetype/CascadiaCode.ttf";

  terminal.colors = let
    colors = (builtins.fromTOML (builtins.readFile ../../homes/petms/dotfiles/alacritty/tokyonight_moon.toml)).colors;
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

  home-manager.config = ../../homes/petms/home.nix;

}
