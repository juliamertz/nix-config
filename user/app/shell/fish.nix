{ lib, pkgs, ... }:
{
  programs.fish = {
    enable = true;
    shellAliases = {
      lg = "lazygit";
      sctl = "sudo systemctl";
      spt = "spotify_player";
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
