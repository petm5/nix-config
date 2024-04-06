{ config, lib, pkgs, ... }: {

  imports = [
    ./base.nix
  ];

  boot.kernelParams = [ "quiet" ];
  boot.consoleLogLevel = 0;

  environment.noXlibs = false;

  documentation.nixos.enable = true;

  fonts.fontconfig.enable = true;
  fonts.fontconfig.subpixel.rgba = "rgb";
  fonts.fontconfig.hinting.style = "slight";

  hardware.brillo.enable = true;

  services.upower.enable = true;

  services.flatpak.enable = true;

  services.greetd = {
    enable = true;
    settings = {
      initial_session.command = "Hyprland";
      initial_session.user = (builtins.elemAt (builtins.filter (u: u.isNormalUser) (builtins.attrValues config.users.users)) 0).name;
      default_session.command = "${config.services.greetd.package}/bin/agreety --cmd Hyprland";
    };
  };

  environment.etc."greetd/environments".text = ''
    Hyprland
  '';

  hardware.opengl.enable = true;

  xdg.portal = {
    enable = true;
    config.common.default = "gtk";
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
    ];
  };

  services.dbus.enable = true;
  programs.dconf.enable = true;

  networking.networkmanager.enable = true;
  networking.networkmanager.plugins = with pkgs; lib.mkForce [
    networkmanager-iodine
    networkmanager-openvpn
  ];

  networking.wireless.iwd.enable = true;
  networking.networkmanager.wifi.backend = "iwd";

  hardware.bluetooth.enable = true;

  services.printing.enable = true;
  hardware.sane.enable = true;
  nixpkgs.config.allowUnfree = true;
  hardware.sane.extraBackends = [ pkgs.hplipWithPlugin ];
  services.ipp-usb.enable = true;

  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;

  systemd.network.wait-online.enable = false;

  sound.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  networking.firewall = {
    allowedTCPPorts = [ 8080 ];
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

}
