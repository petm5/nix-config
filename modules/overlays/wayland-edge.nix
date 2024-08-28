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
      version = "a0450d219fbc8a453876e70f29b9b5c2f76b0c64";
      src = pkgs.fetchFromGitLab {
        domain = "gitlab.freedesktop.org";
        owner = "wlroots";
        repo = "wlroots";
        rev = version;
        hash = "sha256-DkQX2mQcsiDUlaEECBM0i5ERHWp62clOzKqYpVBB9UA=";
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
      version = "ae7c1b139a3c71d3e11fe2477d8b21c36de6770e";
      src = pkgs.fetchFromGitHub {
        owner = "swaywm";
        repo = "sway";
        rev = version;
        hash = "sha256-U7IoChVLxGQZ/giTd2B7ubcIIr8gTIPSH6PAPgz8WaQ=";
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
