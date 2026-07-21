{ config, pkgs, ... }: {

  imports = [
    ./wayland-shell.nix
  ];

  xdg.configFile."niri/config.kdl".source = ./dotfiles/niri/config.kdl;

  programs.bash.enable = true;
  programs.bash.bashrcExtra = ''
    if [ $(tty) == "/dev/tty1" ]; then
      if systemctl --user -q is-active niri.service; then
        exit 1
      fi
      systemctl --user import-environment XDG_SEAT XDG_SESSION_ID XDG_VTNR PATH XDG_SESSION_CLASS XDG_SESSION_TYPE
      systemctl --user --wait start niri.service
      systemctl --user start --job-mode=replace-irreversibly niri-shutdown.target
      systemctl --user unset-environment WAYLAND_DISPLAY XDG_SESSION_TYPE XDG_CURRENT_DESKTOP NIRI_SOCKET
      exit 0
    fi
  '';

  services.gammastep = {
    enable = true;
    latitude = "45";
    longitude = "-76";
    temperature = {
      day = 6500;
      night = 2800;
    };
  };

  home.packages = with pkgs; [ xwayland-satellite brillo playerctl ];

}
