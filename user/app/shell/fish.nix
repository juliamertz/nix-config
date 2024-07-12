{ lib, pkgs, ... }:
{
  home.packages = [ pkgs.fish ]; 
  programs.fish = {
    enable = true;
    shellAliases = {
      lg = "lazygit";
    };
    shellInit = ''
      echo hello world
    '';
  };
}
