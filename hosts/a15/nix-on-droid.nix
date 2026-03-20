{ lib, pkgs, ... }: {

  system.stateVersion = "24.05";

  user.uid = 10482;
  user.gid = 10482;

  user.shell = lib.getExe pkgs.nushell;

  terminal.font = "${pkgs.cascadia-code}/share/fonts/truetype/CascadiaCode.ttf";
  terminal.colors = (pkgs.callPackage ../../modules/colors {}).termux;

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.config = ../../homes/petms/home.nix;

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

}
