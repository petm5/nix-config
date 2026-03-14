{ config, pkgs, lib, ... }: {
   environment.systemPackages = [
      # For debugging and troubleshooting Secure Boot.
      pkgs.sbctl
    ];

    # Lanzaboote currently replaces the systemd-boot module.
    # This setting is usually set to true in configuration.nix
    # generated at installation time. So we force it to false
    # for now.
    boot.loader.systemd-boot.enable = lib.mkForce false;

    boot.lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
      settings.reboot-for-bitlocker = true;
    };

   boot.initrd.systemd.storePaths = [
     "${config.systemd.package}/lib/systemd/systemd-pcrextend"
     "${pkgs.tpm2-tss}/lib"
   ];

   boot.initrd.systemd.additionalUpstreamUnits = [
     "systemd-pcrphase-initrd.service"
   ];

   systemd.additionalUpstreamSystemUnits = [
      "systemd-pcrphase.service"
      "systemd-pcrphase-sysinit.service"
   ];

   environment.etc = {
      systemd-pcrlock-builtin = {
         target = "pcrlock.d";
         source = "${config.systemd.package}/lib/pcrlock.d";
      };
   };
}
