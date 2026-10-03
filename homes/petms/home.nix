{ config, lib, pkgs, ... }:

{

  home.stateVersion = "23.11";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    dig
    zip
    unzip
    gnutar
    gh
    direnv
    ripgrep
  ];

  programs.nushell = {
    enable = true;
    configFile.source = dotfiles/nushell/config.nu;
    environmentVariables = config.home.sessionVariables;
  };

  programs.helix = {
    enable = true;
    defaultEditor = true;
    extraPackages = with pkgs; [
      marksman
      rust-analyzer
      typescript-language-server
      nil
      bash-language-server
      svelte-language-server
    ];
    settings = {
      theme = "cyan_light";
      editor.soft-wrap = {
        enable = true;
        max-wrap = 25;
        max-indent-retain = 20;
      };
    };
    languages.language = [
      {
        name = "c";
        indent = { tab-width = 8; unit = "\t"; };
      }
    ];
  };

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

  programs.aerc.enable = true;

}
