flakePath: let
  flake = import (flakePath + "/flake.nix");
  inherit (flake) nixConfig;
in {

  nix = {
    substituters = nixConfig.extra-substituters;
    trustedPublicKeys = nixConfig.
extra-trusted-public-keys;
  };

}
