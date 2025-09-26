{ config, pkgs, ... }: {

  home.file.".config/niri/config.kdl".source = ./dotfiles/niri/config.kdl;

  programs.fuzzel.enable = true;

  services.mako = {
    enable = true;
    settings.default-timeout = 15000;
  };

  programs.swaylock = {
    enable = true;
    settings = {
      show-failed-attempts = true;
      image = ".wallpaper";
      scaling = "fill";
      indicator-radius = 100;
      indicator-idle-visible = false;
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

  systemd.user.services."swaybg" = {
    Unit = {
      PartOf = "graphical-session.target";
      After = "graphical-session.target";
      Requisite = "graphical-session.target";
      ConditionFileNotEmpty = "%h/.wallpaper";
    };
    Service = {
      ExecStart = "${pkgs.swaybg}/bin/swaybg -m fill -i \"%h/.wallpaper\"";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  programs.bash.enable = true;
  programs.bash.bashrcExtra = ''
    if [ $(tty) == "/dev/tty1" ]; then
      if systemctl --user -q is-active niri.service; then
        exit 1
      fi
      systemctl --user reset-failed
      systemctl --user import-environment
      dbus-update-activation-environment --all
      systemctl --user --wait start niri.service
      systemctl --user start --job-mode=replace-irreversibly niri-shutdown.target
      systemctl --user unset-environment WAYLAND_DISPLAY XDG_SESSION_TYPE XDG_CURRENT_DESKTOP NIRI_SOCKET
      exit 0
    fi
  '';

  home.packages = with pkgs; [ niri xwayland-satellite brillo ];

  systemd.user.services."niri" = {
    Unit = {
      Description = "A scrollable-tiling Wayland compositor";
      BindsTo = "graphical-session.target";
      Before = [ "graphical-session.target" "xdg-desktop-autostart.target" ];
      Wants = [ "graphical-session-pre.target" "xdg-desktop-autostart.target" ];
      After = "graphical-session-pre.target";
      X-RestartIfChanged = false;
    };
    Service = {
      Slice = "session.slice";
      Type = "notify";
      ExecStart = "${pkgs.niri}/bin/niri --session";
    };
  };

  services.gnome-keyring.enable = true;

  xdg.portal = {
    enable = true;
    configPackages = [ pkgs.niri ];
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
  };

}
