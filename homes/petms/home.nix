{ config, lib, pkgs, ... }:

{
  home.username = "petms";
  home.homeDirectory = "/home/petms";

  home.stateVersion = "23.11";

  programs.nushell = {
    enable = true;
    configFile.source = dotfiles/nushell/config.nu;
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
    ];
    settings = {
      theme = lib.mkDefault "base16-terminal";
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

  programs.gpg.enable = true;
  services.gpg-agent.enable = true;
  services.gpg-agent.pinentry.package = pkgs.pinentry-tty;

}
