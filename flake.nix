{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-on-droid = {
      url = "github:nix-community/nix-on-droid";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak/v0.6.0";
    nixpak = {
      url = "github:nixpak/nixpak";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:niri-wm/niri";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "";
    };
    surface-audio = {
      url = "github:petm5/surface-audio/custom-tune";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, lanzaboote, home-manager, nix-on-droid, niri, surface-audio, ... }: {
    nixosConfigurations.peter-pc = nixpkgs.lib.nixosSystem {
      modules = [
        ./hosts/peter-pc/configuration.nix
        lanzaboote.nixosModules.lanzaboote
        home-manager.nixosModules.home-manager
        surface-audio.nixosModules.surface-audio
        {
          home-manager.extraSpecialArgs.flake-inputs = inputs;
          nixpkgs.overlays = [ (self: super: {
            niri = niri.packages.x86_64-linux.niri;
          }) ];
        }
      ];
    };
    homeConfigurations."petms@peter-pc" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [ ./homes/petms/peter-pc.nix ];
    };
    nixOnDroidConfigurations."a15" = nix-on-droid.lib.nixOnDroidConfiguration {
      pkgs = import nixpkgs { system = "aarch64-linux"; };
      modules = [ ./hosts/a15/nix-on-droid.nix ];
    };
  };
}
