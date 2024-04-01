{ config, pkgs, sshAliases, ... }:

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
    themes."base16" = let
      transparent = "none";
      gray = "default";
      black = "black";
      red = "red";
      green = "green";
      blue = "blue";
      yellow = "yellow";
      magenta = "magenta";
      cyan = "cyan";
      light-green = "light-green";
    in {
      "ui.menu" = transparent;
      "ui.menu.selected" = { modifiers = [ "bold" ]; };
      "ui.linenr" = { fg = gray; };
      "ui.linenr.selected" = { modifiers = [ "bold" ]; };
      "ui.selection" = { fg = black; };
      "ui.selection.primary" = { modifiers = [ "reversed" ]; };
      "comment" = { fg = gray; };
      "ui.statusline" = { fg = gray; };
      "ui.statusline.inactive" = { fg = gray; modifiers = [ "underlined" ]; };
      "ui.help" = { fg = gray; };
      "ui.cursor" = { modifiers = [ "reversed" ]; };
      "variable" = yellow;
      "variable.builtin" = magenta;
      "constant.numeric" = red;
      "constant" = green;
      "attributes" = blue;
      "type" = blue;
      "ui.cursor.match" = { modifiers = [ "underlined" ]; };
      "string" = { fg = light-green; modifiers = [ "italic" ]; };
      "variable.other.member" = gray;
      "constant.character.escape" = magenta;
      "function" = { fg = gray; modifiers = [ "italic" ]; };
      "constructor" = magenta;
      "special" = gray;
      "keyword" = magenta;
      "label" = magenta;
      "namespace" = blue;
      "diff.plus" = green;
      "diff.delta" = yellow;
      "diff.minus" = red;
      "diagnostic" = { modifiers = [ "underlined" ]; };
      "info" = blue;
      "hint" = gray;
      "debug" = gray;
      "warning" = yellow;
      "error" = red;
    };
    enable = true;
    defaultEditor = true;
    settings = {
      theme = "base16";
      editor.true-color = true;
      editor.soft-wrap = {
        enable = true;
        max-wrap = 25;
        max-indent-retain = 20;
      };
    };
  };

  programs.ssh = {
    enable = true;
    matchBlocks = sshAliases;
    addKeysToAgent = "1h";
  };

  services.ssh-agent.enable = true;

  programs.git = {
    enable = true;
    userEmail = "petms@proton.me";
    userName = "Peter Marshall";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
