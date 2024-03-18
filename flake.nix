{
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.pre-commit-hooks-nix.follows = "";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, lanzaboote, home-manager }: let
    inherit (nixpkgs) lib;
    mkHomeConfig = name: lib.nameValuePair name (home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [ ./homes/${name}/home.nix ];
      extraSpecialArgs = {
        sshAliases = let
          sshHosts = builtins.filter ({ config, ... }: config.services.openssh.enable)
            (builtins.attrValues self.nixosConfigurations);
        in builtins.listToAttrs (map ({ config, ... }:
          lib.nameValuePair config.networking.hostName {
            hostname = config.networking.fqdnOrHostName;
            port = builtins.head config.services.openssh.ports;
          }
        ) sshHosts);
      };
    });
  in {
    nixosConfigurations.peter-pc = nixpkgs.lib.nixosSystem {
      modules = [
        ./hosts/peter-pc/configuration.nix
        ./hardware/microsoft/surface-pro-9-intel
        lanzaboote.nixosModules.lanzaboote
        ./profiles/secure-boot.nix
      ];
    };

    nixosConfigurations.petms = nixpkgs.lib.nixosSystem {
      modules = [
        ./hosts/petms/configuration.nix
        ./profiles/base.nix
      ];
    };

    homeConfigurations = lib.listToAttrs (map mkHomeConfig [ "petms" "petms@peter-pc" ]);

    devShells.x86_64-linux.surface-kernel = let
     pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in (pkgs.callPackage ./hardware/microsoft/surface-pro-9-intel/kernel/package {
      baseKernel = pkgs.linux_latest;
    }).overrideAttrs (o: {nativeBuildInputs=o.nativeBuildInputs ++ (with pkgs; [ pkg-config ncurses ]);});
  };
}
