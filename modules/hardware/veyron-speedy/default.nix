{ lib, pkgs, ... }: {

  nixpkgs.hostPlatform = {
    system = "armv7l-linux";
    gcc = {
      float-abi = "hard";
      fpu = "neon";
      cpu = "cortex-a17";
    };
  };

  boot.kernelPackages = lib.mkOverride 0 (pkgs.callPackage ./kernel.nix {});

  boot.initrd.includeDefaultModules = false;
  boot.initrd.kernelModules = [ ];

  boot.kernelParams = [ "console=ttyS0,115200" "console=tty0" ];

  hardware.deviceTree = {
    enable = true;
    name = "rk3288-veyron-speedy.dtb";
  };

}
