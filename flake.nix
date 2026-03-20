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
      url = "github:petm5/nix-on-droid/test-native-build";
      # url = "git+file:///home/petms/nix-on-droid/";
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

  nixConfig = {
    extra-substituters = [
      "https://binarycache.petermarshall.ca"
    ];
    extra-trusted-public-keys = [
      "binarycache.petermarshall.ca:xmkaNcypcMm5i/8WxvNUtnuMND2bOoJYu1aUii9Eyao="
      "binarycache.petermarshall.ca-gh:5A6yxY0hRi/qNxygl6IU+1z6NkmLZfdykUTWLciNj/g="
    ];
  };

  outputs = inputs@{ self, nixpkgs, lanzaboote, home-manager, nix-on-droid, niri, surface-audio, ... }: {
    nixosConfigurations.peter-pc = nixpkgs.lib.nixosSystem {
      modules = [
        (import ./modules/nixos/cache.nix self.nixConfig)
        ./hosts/peter-pc/configuration.nix
        lanzaboote.nixosModules.lanzaboote
        home-manager.nixosModules.home-manager
        # surface-audio.nixosModules.surface-audio
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
      modules = [
        (import ./modules/nixos/cache.nix self.nixConfig)
        ./hosts/a15/nix-on-droid.nix
      ];
      bootstrapSystem = "x86_64-linux";
    };
    packages = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" ] (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      lib = pkgs.lib;
      cacheCfg = import ./modules/binary-cache.nix;
    in {
      nixConfigFragment = pkgs.writeText "nix-extra-config" ''
        extra-substituters = ${lib.strings.concatStringsSep " " cacheCfg.substituters}
        extra-trusted-public-keys = ${lib.strings.concatStringsSep " " cacheCfg.trusted-public-keys}
      '';
    });
  };
}
