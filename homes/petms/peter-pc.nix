{

  imports = [ ./desktop-home.nix ./rclone.nix ];

  home.username = "petms";
  home.homeDirectory = "/home/petms";

  programs.git.settings = {
    user.signingKey = "~/.ssh/id_ed25519";
    gpg.format = "ssh";
    commit.gpgsign = true;
  };

}
