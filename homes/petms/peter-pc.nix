{

  imports = [ ./desktop-home.nix ];

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
