{

  imports = [ ./desktop-home.nix ./rclone.nix ];

  home.username = "petms";
  home.homeDirectory = "/home/petms";

  programs.git = {
    signing = {
      key = "~/.ssh/id_ed25519";
      signByDefault = true;
    };
    extraConfig = {
      gpg.format = "ssh";
    };
  };

}
