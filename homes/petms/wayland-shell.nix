{ config, pkgs, ...}: {

  programs.fuzzel.enable = true;

  services.mako = {
    enable = true;
    settings.default-timeout = 15000;
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

}
