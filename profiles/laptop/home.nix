{ pkgs, settings, ... }:
let 
  user = settings.user.username;
in
{
  home.username = user;
  programs.home-manager.enable = true;

  imports = [
    ../../user/app/shell/zsh.nix
    ../../user/app/shell/bash.nix
  ];

  environment.systemPackages = with pkgs; [ neofetch ];
  
  nixpkgs.config.allowUnfree = true;

  home.sessionVariables = {
    EDITOR = settings.user.editor; 
  };

  home.stateVersion = "24.05";
}
