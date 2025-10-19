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
    eog
    file-roller
    gnome-font-viewer
    mpv
    simple-scan
    keepassxc
  ];

  xdg.systemDirs.data = [ "$HOME/.local/share/flatpak/exports/share" "/var/lib/flatpak/exports/share" ];

}
