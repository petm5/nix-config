{

  imports = [ ./desktop-home.nix ./rclone.nix ];

  home.username = "petms";
  home.homeDirectory = "/home/petms";

  programs.git.settings = {
    commit.gpgsign = true;
  };

}
