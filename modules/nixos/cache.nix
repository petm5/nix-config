flakePath: let
  flake = import (flakePath + "/flake.nix");
  inherit (flake) nixConfig;
in {

  nix.settings = {
    substituters = nixConfig.extra-substituters;
    trusted-public-keys = nixConfig.
extra-trusted-public-keys;
  };

}
