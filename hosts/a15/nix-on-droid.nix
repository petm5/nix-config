{ pkgs, ... }: {

  system.stateVersion = "24.05";

  user.shell = "${pkgs.nushell}/bin/nu";

  home-manager.config = ../../homes/petms/home.nix;

}
