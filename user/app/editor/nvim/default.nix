{ lib, config, pkgs, ... }:
{
  home.packages = with pkgs; [ ripgrep ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
  };

  home.file."${config.xdg.configHome}/nvim" = {
    source = ./config;
    recursive = true;
  };
}
