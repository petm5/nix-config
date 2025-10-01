{ config, lib, pkgs, ... }: {

  imports = [
    ./base.nix
  ];

  boot.kernelParams = [ "quiet" ];
  boot.consoleLogLevel = 0;

  boot.loader.timeout = 0;

  services.upower.enable = true;

  hardware.graphics.enable = true;

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
    extraConfig.pipewire = {
      "10-bluetooth" = {
        "properties" = {
          "bluez5.msbc-support" = true;
          "bluez5.sbc-xq-support" = true;
        };
      };
    };
  };

  networking.firewall = {
    allowedTCPPorts = [ 8000 8080 ];
    allowedUDPPorts = [ 1900 5353 ];
    allowedUDPPortRanges = [{ from = 32768; to = 61000; }];
  };

  services.logind.settings.Login = {
    HoldoffTimeoutSec = 2;
    HandlePowerKey = "suspend";
    HandlePowerKeyLongPress = "poweroff";
    HandleLidSwitch = "suspend";
    HandlelidSwitchExternalPower = "ignore";
  };

  services.timesyncd.enable = true;

  security.pam.loginLimits = [
    { domain = "@users"; item = "rtprio"; type = "-"; value = 1; }
    { domain = "@users"; item = "nproc"; type = "hard"; value = 2000; }
  ];

  security.polkit.enable = true;
  security.pam.services.swaylock = {};

  services.udisks2.enable = true;
  services.gvfs.enable = true;
  services.devmon.enable = true;

  programs.gnome-disks.enable = true;

  boot.plymouth = {
    enable = true;
    themePackages = [ (pkgs.callPackage ../../pkgs/plymouth-minimal-theme {}) ];
    theme = "minimal";
  };

  environment.pathsToLink = [ "/share/xdg-desktop-portal" "/share/applications" ];

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chgrp video $sys$devpath/brightness", RUN+="${pkgs.coreutils}/bin/chmod g+w $sys$devpath/brightness"
  '';

}
