{

  networking.wireless.iwd.enable = true;

  networking.wireless.iwd.settings = {
    General = {
      # Prevent tracking across networks
      AddressRandomization = "network";
    };
    Rank = {
      # Prefer faster bands
      BandModifier2_4GHz = 1.0;
      BandModifier5GHz = 2.0;
      BandModifier6GHz = 15.0;
    };
  };

}
