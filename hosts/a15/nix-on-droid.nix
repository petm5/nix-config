{ lib, pkgs, ... }: {

  system.stateVersion = "24.05";

  user.shell = lib.getExe pkgs.nushell;

  terminal.font = "${pkgs.cascadia-code}/share/fonts/truetype/CascadiaCode.ttf";
  terminal.colors = (import ../../modules/colors).termux;

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.config = ../../homes/petms/home.nix;

}
