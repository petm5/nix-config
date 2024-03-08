{ pkgs, ... }: {

  boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.callPackage ./package {
    baseKernel = pkgs.linux_latest;
  });

}
