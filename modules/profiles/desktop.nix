{ config, lib, pkgs, ... }: {

  imports = [
    ./base.nix
  ];

  boot.kernelParams = [ "quiet" ];
  boot.consoleLogLevel = 0;

  fonts.fontconfig.enable = true;
  fonts.fontconfig.subpixel.rgba = "rgb";
  fonts.fontconfig.hinting.style = "slight";

  hardware.brillo.enable = true;

  services.upower.enable = true;

  services.flatpak.enable = true;

  hardware.graphics.enable = true;

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
    lidSwitchExternalPower = "lock";
  };

  security.pam.services.swaylock = {};

  services.timesyncd.enable = true;

  services.greetd = {
    enable = true;
    settings = {
      initial_session = lib.mkIf config.services.displayManager.autoLogin.enable {
        user = config.services.displayManager.autoLogin.user;
        command = "bash";
      };
      default_session = {
        command = "${config.services.greetd.package}/bin/agreety --cmd bash";
      };
    };
  };

  security.pam.loginLimits = [
    { domain = "@users"; item = "rtprio"; type = "-"; value = 1; }
  ];

}
