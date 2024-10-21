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
  };

}
