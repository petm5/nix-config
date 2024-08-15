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

  hardware.graphics.enable = true;

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

  nixpkgs.overlays = [(self: super: {
    wayland_edge = super.wayland.overrideAttrs (finalAttrs: prevAttrs: rec {
      version = "5b692b50b9e3d379005633d4ac20068d2069849d";
      src = pkgs.fetchFromGitLab {
        domain = "gitlab.freedesktop.org";
        owner = "wayland";
        repo = "wayland";
        rev = version;
        hash = "sha256-F+gz+55ixfwf6TmgyF25I7JM1Q2uA+9ddiQRj67ZWgg=";
      };
      patches = [];
      nativeBuildInputs = prevAttrs.nativeBuildInputs ++ (with self; [
        cmake
      ]);
    });
    wayland-protocols_edge = super.wayland-protocols.overrideAttrs (finalAttrs: prevAttrs: rec {
      version = "f4925c9313d26689918c1d1a138ec4819caeb77c";
      src = pkgs.fetchFromGitLab {
        domain = "gitlab.freedesktop.org";
        owner = "wayland";
        repo = "wayland-protocols";
        rev = version;
        hash = "sha256-URMkmlawIM2DLzEN8BfltnKCPjjec9CoxbyVWUT5MpA=";
      };
      wayland = self.wayland_edge;
    });
    wlroots_edge = super.wlroots.overrideAttrs (finalAttrs: prevAttrs: rec {
      version = "3103ea3af9e1a6a8d6ad9a4e6d78bee73e5c29a5";
      src = pkgs.fetchFromGitLab {
        domain = "gitlab.freedesktop.org";
        owner = "wlroots";
        repo = "wlroots";
        rev = version;
        hash = "sha256-VufMAksgNpV/Zaiqh5eqggnEaDsLXo+1HxAnJEGiiic=";
      };
      nativeBuildInputs = prevAttrs.nativeBuildInputs ++ (with self; [
        cmake
      ]);
      buildInputs = with self; [
        libGL
        libcap
        libinput
        libpng
        libxkbcommon
        mesa
        pixman
        seatd
        vulkan-loader
        wayland_edge
        wayland-protocols_edge
        xorg.libX11
        xorg.xcbutilerrors
        xorg.xcbutilimage
        xorg.xcbutilrenderutil
        xorg.xcbutilwm
        lcms
        libdisplay-info
        libliftoff
      ];
      enableXWayland = false;
    });
    sway-unwrapped = super.sway-unwrapped.overrideAttrs (finalAttrs: prevAttrs: rec {
      version = "c30c4519079e804c35e71810875c10f48097d230";
      src = pkgs.fetchFromGitHub {
        owner = "swaywm";
        repo = "sway";
        rev = version;
        hash = "sha256-/M5oq8bHnXm0eKacxyVMJuK+JPsnhUGw2qrXkzrB2D4=";
      };
      buildInputs = with self; [
        libGL wayland_edge libxkbcommon pcre2 json_c libevdev
        pango cairo libinput gdk-pixbuf librsvg
        wayland-protocols_edge libdrm
        wlroots_edge
      ];
      nativeBuildInputs = with self; [
        meson ninja pkg-config wayland-scanner scdoc cmake
      ];
      mesonFlags = let
        inherit (lib.strings) mesonEnable mesonOption;
        sd-bus-provider = if finalAttrs.systemdSupport then "libsystemd" else "basu";
        in [
          (mesonOption "sd-bus-provider" sd-bus-provider)
          (mesonEnable "tray" finalAttrs.trayEnabled)
        ];
    });
  })];

}
