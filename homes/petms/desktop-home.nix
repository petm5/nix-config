{ config, lib, pkgs, ... }: {

  imports = [
    ./home.nix
    ./theme.nix
    ./niri.nix
    ./waybar.nix
    ./firefox.nix
  ];

  programs.alacritty = {
    enable = true;
    settings.terminal = {
      shell = "${pkgs.nushell}/bin/nu";
    };
  };

  services.mpd.enable = true;
  xdg.userDirs.enable = true;

  programs.password-store.enable = true;
  programs.password-store.package = pkgs.pass.withExtensions (exts: [ exts.pass-otp ]);

  services.pass-secret-service.enable = true;
  services.pass-secret-service.storePath = "$\{XDG_DATA_HOME\}/password-store";

  home.sessionVariables = {
    TERMINAL = "${pkgs.alacritty}/bin/alacritty";
  };

}
