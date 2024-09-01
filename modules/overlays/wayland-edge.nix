{ config, lib, pkgs, ... }: {

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
      version = "4878e025a5fb95d8d14a05088974af60cbafebd0";
      src = pkgs.fetchFromGitLab {
        domain = "gitlab.freedesktop.org";
        owner = "wayland";
        repo = "wayland-protocols";
        rev = version;
        hash = "sha256-ryyv1RZqpwev1UoXRlV8P1ujJUz4m3sR89iEPaLYSZ4=";
      };
      wayland = self.wayland_edge;
    });
    wlroots_edge = super.wlroots.overrideAttrs (finalAttrs: prevAttrs: rec {
      version = "beb9a9ad0a38867154b7606911c33ffa5ecf759f";
      src = pkgs.fetchFromGitLab {
        domain = "gitlab.freedesktop.org";
        owner = "wlroots";
        repo = "wlroots";
        rev = version;
        hash = "sha256-ZlNFxwj3c5zKiSfokA27zhJ+Yar8cma4fj6N/ulI0VM=";
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
    sway-unwrapped_edge = super.sway-unwrapped.overrideAttrs (finalAttrs: prevAttrs: rec {
      version = "980a4e02113789d0cca94aa023557c6f6e87ec73";
      src = pkgs.fetchFromGitHub {
        owner = "swaywm";
        repo = "sway";
        rev = version;
        hash = "sha256-qciZeQghlLV5aMuOnex3LvFU9vTa941RMlUkdvj0QTU=";
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
    sway_edge = super.sway.override {
      sway-unwrapped = self.sway-unwrapped_edge;
      enableXWayland = false;
    };
  })];

}
