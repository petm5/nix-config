{ pkgs, ... }: {

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
      theme = "tokyonight_moon";
      editor.soft-wrap = {
        enable = true;
        max-wrap = 25;
        max-indent-retain = 20;
      };
    };
  };

  home.packages = with pkgs; [
    dig
    zip
    unzip
    btop
    gh
    direnv
    ripgrep
  ];

}
