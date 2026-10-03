{ config, pkgs, lib, ... }:
let
  cfg = config.theme;

  gtkThemeName = if cfg.darkMode then "Adwaita-dark" else "Adwaita";
in
{

  options.theme = {
    darkMode = lib.mkEnableOption "dark theme across GTK, QT, cursor and system settings";
    colors = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "Attrset containing the active color scheme in various formats";
    };
  };

  config = {

    theme.colors = pkgs.callPackage ../../modules/colors {
      darkTheme = cfg.darkMode;
    };

    home.packages = with pkgs; [
      adwaita-icon-theme
      papirus-icon-theme
      numix-cursor-theme
    ];

    home.pointerCursor = {
      enable = true;
      gtk.enable = true;
      x11.enable = true;
      package = pkgs.numix-cursor-theme;
      name = "Numix-Cursor";
      size = 24;
    };

    gtk = {
      enable = true;

      iconTheme.name = "Papirus";

      gtk3.theme.name = gtkThemeName;
      gtk2.theme.name = gtkThemeName;
      gtk2.theme.package = pkgs.gnome-themes-extra;

      font = {
        name = "Roboto";
        size = 10.5;
      };
    };

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = if cfg.darkMode then "prefer-dark" else "prefer-light";
        accent-color = "teal";
      };
      "org/gnome/desktop/a11y/applications" = {
        screen-keyboard-enabled = true;
      };
      "org/gnome/desktop/wm/preferences" = {
        button-layout = "";
      };
    };

    qt = {
      enable = true;
      platformTheme.name = "gtk3";
      style.name = if cfg.darkMode then "adwaita-dark" else "adwaita";
    };

  };

}
