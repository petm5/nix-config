{

  imports = [ ./desktop-home.nix ];

  wayland.windowManager.hyprland.settings = {
    monitor = [
      "eDP-1,2880x1920@120,1920x0,2,bitdepth,8"
      "DP-2,highres,0x0,auto"
    ];
  };

}
