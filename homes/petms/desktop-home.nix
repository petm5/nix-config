{ config, lib, pkgs, flake-inputs, ... }: {

  imports = [
    ./home.nix
    ./theme.nix
    ./niri.nix
    ./waybar.nix
    ./firefox.nix
    flake-inputs.nix-flatpak.homeManagerModules.nix-flatpak
  ];

  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        shell = lib.getExe pkgs.nushell;
        term = "xterm-256color";
      };
    };
  };

  xdg.userDirs.enable = true;

  programs.password-store.enable = true;
  programs.password-store.package = pkgs.pass.withExtensions (exts: [ exts.pass-otp ]);

  home.sessionVariables = {
    TERMINAL = "${pkgs.foot}/bin/footclient";
  };

  home.packages = with pkgs; [
    mpv
    keepassxc
  ];

  services.flatpak.enable = true;
  services.flatpak.packages = [
    "org.gnome.Calculator"
    "org.gnome.Loupe"
    "org.gnome.SimpleScan"
    "org.gnome.FileRoller"
    "org.gnome.font-viewer"
  ];

  services.flatpak.overrides = {
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


  xdg.systemDirs.data = [ "$HOME/.local/share/flatpak/exports/share" "/var/lib/flatpak/exports/share" ];

}
