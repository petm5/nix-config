{ config, pkgs, ...}:
let
  inherit (config.theme) colors;
in
{

  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        icon-theme = config.gtk.iconTheme.name;
        font = "DejaVu Sans Mono";
        use-bold = true;
      };
      colors = colors.fuzzel;
    };
  };

  services.mako = {
    enable = true;
    settings = {
      default-timeout = 15000;
      text-color = "${colors.alacritty.primary.foreground}";
      border-color = "${colors.alacritty.primary.foreground}";
      background-color = "${colors.alacritty.primary.background}";
      border-size = 2;
      border-radius = 4;
      width = 400;
      height = 200;
      padding = "20";
      margin = "20";
    };
  };

  programs.quickshell.enable = true;
  programs.quickshell.systemd.enable = true;

  xdg.configFile."quickshell".source = ./dotfiles/quickshell;

  programs.swaylock = {
    enable = true;
    settings = {
      show-failed-attempts = true;
      indicator-radius = 100;
      indicator-idle-visible = false;
      color = "54708e";
    };
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "${config.programs.swaylock.package}/bin/swaylock -fF";
        before_sleep_cmd = "${pkgs.systemd}/bin/loginctl lock-session";
        after_sleep_cmd = "${pkgs.systemd}/bin/loginctl unlock-session";
      };
      listener = [
        {
          timeout = 300;
          on-timeout = "${pkgs.systemd}/bin/loginctl lock-session";
        }
        {
          timeout = 600;
          on-timeout = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ];
    };
  };

  services.awww.enable = true;

  gtk.gtk3.extraCss = ''
    window, .titlebar, headerbar, decoration {
      border-radius: 0;
      box-shadow: none;
    }
  '';

}
