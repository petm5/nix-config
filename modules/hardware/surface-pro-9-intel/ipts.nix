{

  services.iptsd.enable = true;
  services.iptsd.config = {
    Touchscreen = {
      DisableOnPalm = true;
      DisableOnStylus = true;
    };
    Stylus = {
      TipDistance = 0.04;
    };
    Contacts = {
      Neutral = "average";
      ActivationThreshold = 8;
      DeactivationThreshold = 6;
      SizeMin = 0.1;
    };
  };

}
