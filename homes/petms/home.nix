{ config, pkgs, ... }:

{
  home.username = "petms";
  home.homeDirectory = "/home/petms";

  home.stateVersion = "23.11";
  
  home.packages = with pkgs; [
    miniupnpc
    arp-scan
  ];

  programs.nushell = {
    enable = true;
    configFile.source = dotfiles/nushell/config.nu;
    envFile.source = dotfiles/nushell/env.nu;
  };

  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      theme = "nord";
      editor.soft-wrap = {
        enable = true;
        max-wrap = 25;
        max-indent-retain = 20;
      };
    };
  };

  programs.ssh = {
    enable = true;
    addKeysToAgent = "1h";
  };

  services.ssh-agent.enable = true;

  programs.git = {
    enable = true;
    userEmail = "petms@proton.me";
    userName = "Peter Marshall";
  };

  programs.ssh.matchBlocks = {
    "petms" = {
      user = "admin";
      hostname = "opcc.opcc.tk";
      port = 2273;
    };
    "dev" = {
      user = "petms";
      hostname = "opcc.opcc.tk";
      port = 2274;
    };
  };

}
