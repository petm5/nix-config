{ config, lib, pkgs, ... }: {

  security.apparmor.enable = true;
  security.apparmor.policies = {
    pam_binaries = {
      state = "enforce";
      profile = ''
        #include <tunables/global>
        ${pkgs.su}/bin/su {
          #include "${pkgs.apparmorRulesFromClosure { name = "su"; } pkgs.su}"
          #include <abstractions/authentication>
          #include <abstractions/base>
          #include <abstractions/nameservice>
          # Include the file with all of our username/group to role mappings
          #include <pam/mappings>
          capability chown,
          capability setgid,
          capability setuid,
          capability audit_write,
          owner /etc/environment r,
          owner /etc/shells r,
          owner /etc/default/locale r,
          owner @{HOMEDIRS}/*/.Xauthority rw,
          owner @{HOMEDIRS}/*/.Xauthority-c w,
          owner @{HOMEDIRS}/*/.Xauthority-l w,
          @{HOME}/.xauth* rw,
          owner @{PROC}/sys/kernel/ngroups_max r,
          /usr/bin/xauth rix,
          owner /var/run/utmp rwk,
          /run/current-system/sw/etc/security/limits.d/*.conf r,
          /run/current-system/sw/etc/pam/environment r,
        }
      '';
    };
    pam_roles = {
      state = "enforce";
      profile = ''
        #include <tunables/global>
        profile default_user {
          #include <abstractions/base>
          #include <abstractions/bash>
          #include "${pkgs.apparmorRulesFromClosure { name = "bash"; } pkgs.bash}"
          #include <abstractions/consoles>
          #include <abstractions/nameservice>
          deny capability sys_ptrace,
          owner /** rkl,
          @{PROC}/** r,
          /nix/store/*/bin/**  Pixmr,
          /nix/store/*/lib/**  Pixmr,
          owner @{HOMEDIRS}/ w,
          owner @{HOMEDIRS}/** w,
        }
      '';
    };
  };
  security.apparmor.includes."pam/mappings" = ''
    ^DEFAULT {
      #include <abstractions/authentication>
      #include <abstractions/nameservice>
      capability dac_override,
      capability setgid,
      capability setuid,
      /etc/default/su r,
      /etc/environment r,
      @{HOMEDIRS}/.xauth* w,
      /bin/{,b,d,rb}ash Px -> default_user,
      /bin/{c,k,tc}sh Px -> default_user,
    }
    # ^wheel {
    #   #include <abstractions/authentication>
    #   #include <abstractions/nameservice>
    #   capability dac_override,
    #   capability setgid,
    #   capability setuid,
    #   /etc/default/su r,
    #   /etc/environment r,
    #   @{HOMEDIRS}/.xauth* w,
    #   /bin/{,b,d,rb}ash Ux,
    #   /bin/{c,k,tc}sh Ux,
    # }
  '';

  security.pam.services.su.enableAppArmor = true;

}
