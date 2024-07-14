{ lib, pkgs, ... }:
{
  programs.fish = {
    enable = true;
    shellAliases = {
      lg = "lazygit";
    };
    shellInit = ''
      echo hello world
    '';
  };

  home.packages = with pkgs; [ 
    bat
    fzf
    jq
    yq
    ripgrep
  ]; 
}
