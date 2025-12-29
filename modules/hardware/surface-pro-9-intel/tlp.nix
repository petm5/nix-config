{ pkgs, ... }:
let

  powerLimitScript = pkgs.writeScript "set-power-limit" ''
    #!${pkgs.runtimeShell}

    ac_dev="/sys/class/power_supply/ADP1/online"
    rapl_short="/sys/class/powercap/intel-rapl:1/constraint_1_power_limit_uw"
    rapl_long="/sys/class/powercap/intel-rapl:1/constraint_0_power_limit_uw"

    if [ "$(cat "$ac_dev")" == 0 ]
    then
      echo 6000000 > $rapl_short
      echo 3400000 > $rapl_long
    else
      echo 52000000 > $rapl_short
      echo 52000000 > $rapl_long
    fi
  '';

in {

  services.power-profiles-daemon.enable = false;

  services.tlp.enable = true;
  services.tlp.settings = {
    PLATFORM_PROFILE_ON_AC = "balanced-performance";
    PLATFORM_PROFILE_ON_BAT = "low-power";
    RUNTIME_PM_ON_AC = "auto";
    RUNTIME_PM_ON_BAT = "auto";
    CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
    CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
    CPU_BOOST_ON_AC = 1;
    CPU_BOOST_ON_BAT = 0;
    CPU_HWP_DYN_BOOST_ON_AC = 1;
    CPU_HWP_DYN_BOOST_ON_BAT = 0;
    CPU_MIN_PERF_ON_AC = 0;
    CPU_MAX_PERF_ON_AC = 100;
    CPU_MIN_PERF_ON_BAT = 0;
    CPU_MAX_PERF_ON_BAT = 60;
    CPU_SCALING_MAX_FREQ_ON_AC = 4400000;
    CPU_SCALING_MAX_FREQ_ON_BAT = 4400000;
    USB_AUTOSUSPEND = 1;
    USB_EXCLUDE_BTUSB = 0;
    INTEL_GPU_MIN_FREQ_ON_AC = 100;
    INTEL_GPU_MIN_FREQ_ON_BAT = 100;
    INTEL_GPU_MAX_FREQ_ON_AC = 1200;
    INTEL_GPU_MAX_FREQ_ON_BAT = 400;
    INTEL_GPU_BOOST_FREQ_ON_AC = 1200;
    INTEL_GPU_BOOST_FREQ_ON_BAT = 400;
    PCIE_ASPM_ON_AC = "default";
    PCIE_ASPM_ON_BAT = "powersupersave";
  };

  systemd.services."power-limit" = {
    serviceConfig = {
      Type = "oneshot";
      ExecStart = powerLimitScript;
    };
    after = [ "sysfs.mount" ];
    wantedBy = [ "multi-user.target" ];
  };

  services.udev.extraRules = ''
    ACTION=="change", SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_TYPE}=="Mains", \
    RUN+="${powerLimitScript}"
  '';

}
