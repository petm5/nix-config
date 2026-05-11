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
      measuredBoot = {
        enable = true;
        pcrs = [
          0
          1
          2
          3
          4
        ];
        staticMeasurements = {
          "600-returning-from-efi-application".source = pkgs.writeText "600-returning-from-efi-application.pcrlock" ''
            {"records":[{"pcr":4,"digests":[{"hashAlg":"sha256","digest":"7044f06303e54fa96c3fcd1a0f11047c03d209074470b1fd60460c9f007e28a6"}]},{"pcr":4,"digests":[{"hashAlg":"sha256","digest":"3d6772b4f84ed47595d72a2c4c5ffd15f5bb72c7507fe26f2aaee2c69d5633ba"}]}]}
           '';
         };
      };
      configurationLimit = 8;
    };

}
