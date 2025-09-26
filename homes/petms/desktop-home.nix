{ config, lib, pkgs, ... }: {

  imports = [
    ./home.nix
    ./theme.nix
    ./niri.nix
    ./waybar.nix
    ./firefox.nix
  ];

  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        shell = "${pkgs.nushell}/bin/nu";
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

  xdg.portal.enable = true;

  home.packages = with pkgs; [
    nautilus
    eog
    file-roller
    gnome-font-viewer
    system-config-printer
    mpv
    pavucontrol
    simple-scan
    flatpak
    gnome-software
    keepassxc
  ];

  xdg.systemDirs.data = [ "$HOME/.local/share/flatpak/exports/share" "/var/lib/flatpak/exports/share" ];

}
