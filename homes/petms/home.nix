{ config, lib, pkgs, ... }:

{

  home.stateVersion = "23.11";

  programs.home-manager.enable = true;

  imports = [ ./base.nix ];

  programs.ssh = {
    enable = true;
    package = pkgs.openssh;
    enableDefaultConfig = false;
    settings = {
      "*" = {
        addKeysToAgent = "1h";
      };
      "origin.opcc.tk".user = "admin";
    };
  };

  programs.git.enable = true;
  programs.git.settings = {
    user = {
      email = "pm@petermarshall.ca";
      name = "Peter Marshall";
      signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOb7YI8lV66xYOyTCayNAz814Ny/ZLh3MTdFfCVSz6Lf";
    };
    gpg.format = "ssh";
    gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
  };

  programs.gpg.enable = true;
  services.gpg-agent.enable = true;
  services.gpg-agent.pinentry.package = pkgs.pinentry-tty;

  programs.nushell.environmentVariables = config.home.sessionVariables;

}
