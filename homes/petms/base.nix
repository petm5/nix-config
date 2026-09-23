{ lib, pkgs, ... }: {

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
      svelte-language-server
    ];
    settings = {
      theme = lib.mkDefault "tokyonight_moon";
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

  home.packages = with pkgs; [
    dig
    zip
    unzip
    gnutar
    btop
    gh
    direnv
    ripgrep
  ];

}
