{ lib, config, pkgs, ... }:
{
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
