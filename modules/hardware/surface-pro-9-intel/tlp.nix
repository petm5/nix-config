{

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
    CPU_MAX_PERF_ON_BAT = 15;
    CPU_SCALING_MAX_FREQ_ON_AC = 4400000;
    CPU_SCALING_MAX_FREQ_ON_BAT = 4400000;
    USB_AUTOSUSPEND = 1;
    USB_EXCLUDE_BTUSB = 0;
    INTEL_GPU_MIN_FREQ_ON_AC = 0;
    INTEL_GPU_MIN_FREQ_ON_BAT = 0;
    INTEL_GPU_MAX_FREQ_ON_AC = 1200;
    INTEL_GPU_MAX_FREQ_ON_BAT = 400;
    INTEL_GPU_BOOST_FREQ_ON_AC = 1200;
    INTEL_GPU_BOOST_FREQ_ON_BAT = 400;
    PCIE_ASPM_ON_AC = "default";
    PCIE_ASPM_ON_BAT = "powersupersave";
  };

}
