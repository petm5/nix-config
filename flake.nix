{
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://peter-marshall5.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "peter-marshall5.cachix.org-1:mQptwqO4TiqAzDHgDiYzB6hE8PuZERugA8DFILz4Ex4="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.pre-commit-hooks-nix.follows = "";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, lanzaboote, home-manager }: let
    inherit (nixpkgs) lib;
  in {
    nixosConfigurations.peter-pc = nixpkgs.lib.nixosSystem {
      modules = [
        ./hosts/peter-pc/configuration.nix
        lanzaboote.nixosModules.lanzaboote
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.petms = import ./homes/petms/peter-pc.nix;
        }
      ];
    };
  };
}
