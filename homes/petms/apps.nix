{ config, lib, pkgs, ... }: {

  imports = [
    ./firefox.nix
  ];

  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        shell = lib.getExe pkgs.nushell;
        term = "xterm-256color";
        font = "Cascadia Code:size=10";
        line-height = "13";
        pad = "10x10";
        dpi-aware = "no";
      };
      colors-dark = config.theme.colors.foot;
    };
  };

  home.sessionVariables = {
    TERMINAL = "${pkgs.foot}/bin/footclient";
  };

  home.packages = with pkgs; [
    btop
    keepassxc
  ];

  programs.mpv = {
    enable = true;
    config.hwdec = "auto";
    scripts = with pkgs.mpvScripts; [ mpris ];
  };

  services.flatpak = {
    enable = true;
    packages = [
      "org.gnome.Calculator"
      "org.gnome.Loupe"
      "org.gnome.SimpleScan"
      "org.gnome.FileRoller"
      "org.gnome.font-viewer"
    ];
    overrides = {
      global.Context = {
        sockets = [
          "wayland" "!x11" "!fallback-x11"
          "!system-bus" "!session-bus"
          "!ssh-auth"
        ];
        devices = ["!all" "!input" "dri"];
        filesystems = [
          "!host" "!home"
        ];
      };
    };
  };

  xdg.systemDirs.data = [ "$HOME/.local/share/flatpak/exports/share" "/var/lib/flatpak/exports/share" ];

}
