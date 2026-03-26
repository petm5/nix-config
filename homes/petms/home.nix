{ lib, pkgs, ... }:

{

  home.stateVersion = "23.11";

  programs.home-manager.enable = true;

  programs.nushell = {
    enable = true;
    configFile.source = dotfiles/nushell/config.nu;
    extraConfig = ''
      use ${./dotfiles/nushell/motd.nu} show_motd
      show_motd
    '';
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
      theme = "tokyonight_moon";
      editor.soft-wrap = {
        enable = true;
        max-wrap = 25;
        max-indent-retain = 20;
      };
    };
  };

  programs.ssh = {
    enable = true;
    package = pkgs.openssh;
    enableDefaultConfig = false;
    matchBlocks."*" = {
      addKeysToAgent = "1h";
    };
    matchBlocks."origin.opcc.tk".user = "admin";
    matchBlocks."services-1.logotherapy.ca" = {
      proxyCommand = "${pkgs.websocat}/bin/websocat --binary wss://services-1.logotherapy.ca/";
      serverAliveInterval = 30;
      user = "ubuntu";
    };
  };

  programs.git.enable = true;
  programs.git.settings = {
    user = {
      email = "petms@proton.me";
      name = "Peter Marshall";
      signingKey = "~/.ssh/id_ed25519.pub";
    };
    gpg.format = "ssh";
    gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
  };

  programs.gpg.enable = true;
  services.gpg-agent.enable = true;
  services.gpg-agent.pinentry.package = pkgs.pinentry-tty;

  home.packages = with pkgs; [
    dig
    zip
    unzip
    btop
    gh
    direnv
  ];

}
