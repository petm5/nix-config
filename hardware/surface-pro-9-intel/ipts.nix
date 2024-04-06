{

  services.iptsd.enable = true;
  services.iptsd.config = {
    Touch = {
      DisableOnPalm = true;
      DisableOnStylus = true;
    };
    Stylus = {
      TipDistance = 0.04;
    };
  };

}
