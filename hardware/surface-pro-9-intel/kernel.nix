{ pkgs, ... }: {

  boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.callPackage ../../pkgs/linux-surface {
    linux = pkgs.linux_latest;
  });

}
