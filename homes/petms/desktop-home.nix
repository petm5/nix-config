{ flake-inputs, ... }: {

  imports = [
    ./home.nix
    ./fonts.nix
    ./theme.nix
    ./apps.nix
    ./niri.nix
    flake-inputs.nix-flatpak.homeManagerModules.nix-flatpak
  ];

  xdg.userDirs.enable = true;
  xdg.userDirs.setSessionVariables = false;

  services.ssh-agent.enable = true;

}
