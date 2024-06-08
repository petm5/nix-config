{

  services.power-profiles-daemon.enable = false;

  services.tlp.enable = true;
  services.tlp.settings = {
    PCIE_ASPM_ON_BAT = "powersupersave";
    PCIE_ASPM_ON_AC = "powersave";
    PLATFORM_PROFILE_ON_AC = "performance";
    PLATFORM_PROFILE_ON_BAT = "low-power";
    RUNTIME_PM_ON_AC = "auto";
    RUNTIME_PM_ON_BAT = "auto";
    RUNTIME_PM_BLACKLIST_MODULES = "snd_hda_audio";
    CPU_SCALING_GOVERNOR_ON_AC = "powersave";
    CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
    CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
    CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
    CPU_BOOST_ON_AC = 1;
    CPU_BOOST_ON_BAT = 0;
    CPU_HWP_DYN_BOOST_ON_AC = 1;
    CPU_HWP_DYN_BOOST_ON_BAT = 0;
    CPU_MIN_PERF_ON_AC = 10;
    CPU_MAX_PERF_ON_AC = 100;
    CPU_MIN_PERF_ON_BAT = 10;
    CPU_MAX_PERF_ON_BAT = 30;
    INTEL_GPU_MIN_FREQ_ON_AC = 100;
    INTEL_GPU_MIN_FREQ_ON_BAT = 100;
    INTEL_GPU_MAX_FREQ_ON_AC = 1200;
    INTEL_GPU_MAX_FREQ_ON_BAT = 200;
    INTEL_GPU_BOOST_FREQ_ON_AC = 1200;
    INTEL_GPU_BOOST_FREQ_ON_BAT = 300;
  };

}
