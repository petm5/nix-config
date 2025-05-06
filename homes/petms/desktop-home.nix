{ config, lib, pkgs, ... }: {

  imports = [
    ./home.nix
    ./theme.nix
    ./niri.nix
    ./waybar.nix
    ./firefox.nix
  ];

  home.packages = with pkgs; [
    pavucontrol
    simple-scan
    nautilus
    eog
    file-roller
    gnome-font-viewer
    system-config-printer
    mpv
  ];

  programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium;
    commandLineArgs = [
      "--ozone-platform=wayland" "--enable-features=TouchpadOverscrollHistoryNavigation" "--enable-features=VaapiVideoDecoder,VaapiIgnoreDriverChecks,Vulkan,DefaultANGLEVulkan,VulkanFromANGLE"
    ];
  };

  programs.alacritty = {
    enable = true;
    settings.terminal = {
      shell = "${pkgs.nushell}/bin/nu";
    };
  };

  services.mpd.enable = true;
  xdg.userDirs.enable = true;

  programs.gpg.enable = true;
  services.gpg-agent.enable = true;

  programs.password-store.enable = true;
  programs.password-store.package = pkgs.pass.withExtensions (exts: [ exts.pass-otp ]);

  services.pass-secret-service.enable = true;
  services.pass-secret-service.storePath = "$\{XDG_DATA_HOME\}/password-store";

}
