{

  imports = [ ./desktop-home.nix ];

  programs.git.signing = {
    key = "BADD3759FA8A5A03";
    signByDefault = true;
  };

}
