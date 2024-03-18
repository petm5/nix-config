{ config, lib, pkgs, ... }: {

  imports = [
    ../../profiles/desktop.nix
  ];

  networking.hostName = "peter-pc";
  
  users.users.petms = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" ];
  };

  time.timeZone = "America/Toronto";

  console.keyMap = "us";

  services.xserver.displayManager.autoLogin = {
    enable = true;
    user = "petms";
  };

  networking.wireless.iwd.settings = {
    General = {
      Country = "CA";
      # Prevent tracking across networks
      AddressRandomization = "network";
    };
    Rank = {
      # Prefer faster bands
      BandModifier2_4GHz = 1.0;
      BandModifier5GHz = 3.0;
      BandModifier6GHz = 10.0;
    };
  };

  zramSwap.enable = true;

  security.tpm2.enable = true;

  system.stateVersion = "24.05";

}
