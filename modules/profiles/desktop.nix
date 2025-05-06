{ config, lib, pkgs, ... }: {

  imports = [
    ./base.nix
  ];

  boot.kernelParams = [ "quiet" ];
  boot.consoleLogLevel = 0;

  boot.loader.timeout = 0;

  fonts.fontconfig.enable = true;
  fonts.fontconfig.subpixel.rgba = "rgb";
  fonts.fontconfig.hinting.style = "slight";

  hardware.brillo.enable = true;

  services.upower.enable = true;

  services.flatpak.enable = true;

  hardware.graphics.enable = true;

  environment.variables = {
    WLR_RENDERER = "vulkan";
  };

  xdg.portal = {
    enable = true;
    config.common.default = "gtk";
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
    ];
  };

  services.dbus.enable = true;
  programs.dconf.enable = true;

  hardware.bluetooth.enable = true;

  services.printing.enable = true;
  hardware.sane.enable = true;
  services.ipp-usb.enable = true;

  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;

  systemd.network.wait-online.enable = false;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  networking.firewall = {
    allowedTCPPorts = [ 8000 8080 ];
    allowedUDPPorts = [ 1900 5353 ];
    allowedUDPPortRanges = [{ from = 32768; to = 61000; }];
  };

  services.logind = {
    powerKey = "suspend";
    powerKeyLongPress = "poweroff";
    lidSwitch = "suspend";
    lidSwitchExternalPower = "ignore";
    extraConfig = "HoldoffTimeoutSec=0";
  };

  programs.niri.enable = true;
  programs.niri.package = pkgs.niri;
  services.hypridle.enable = true;

  security.pam.services.swaylock = {};

  services.timesyncd.enable = true;

  security.pam.loginLimits = [
    { domain = "@users"; item = "rtprio"; type = "-"; value = 1; }
  ];

  environment.systemPackages = with pkgs; [
    libavif
    libwebp
    dig
    unzip
  ];

  programs.gdk-pixbuf.modulePackages = with pkgs; [
    libavif
    webp-pixbuf-loader
  ];

  services.udisks2.enable = true;
  services.gvfs.enable = true;
  services.devmon.enable = true;

  programs.gnome-disks.enable = true;
  programs.geary.enable = true;

  boot.plymouth = {
    enable = true;
    themePackages = [ (pkgs.callPackage ../plymouth/minimal {}) ];
    theme = "minimal";
  };

}
