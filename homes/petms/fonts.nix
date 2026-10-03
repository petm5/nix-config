{ pkgs, ... }: {

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
  ];

}
