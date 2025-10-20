{

  programs.waybar.enable = true;
  programs.waybar.systemd.enable = true;

  xdg.configFile."waybar/config".source = ./dotfiles/waybar/config;
  xdg.configFile."waybar/style.css".source = ./dotfiles/waybar/style.css;

}
