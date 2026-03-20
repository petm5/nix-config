nixConfig: {

  nix.settings = {
    substituters = nixConfig.extra-substituters;
    trusted-public-keys = nixConfig.
extra-trusted-public-keys;
  };

}
