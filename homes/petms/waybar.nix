{ pkgs, ...}: {

  programs.waybar.enable = true;
  programs.waybar.systemd.enable = true;

  programs.waybar.package = pkgs.waybar.overrideAttrs {
   withMediaPlayer = true;
  };

  xdg.configFile."waybar/config".source = ./dotfiles/waybar/config;
  xdg.configFile."waybar/style.css".source = ./dotfiles/waybar/style.css;

}
