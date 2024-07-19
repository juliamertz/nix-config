{ pkgs, settings, ... }:
let 
  user = settings.user.username;
in
{
  home.username = user;
  home.homeDirectory = "/home/${user}";

  programs.home-manager.enable = true;

  imports = [
    ../../user/app/shell/bash.nix
  ];

  nixpkgs.config.allowUnfree = true;

  home.sessionVariables = {
    EDITOR = settings.user.editor; 
  };

  home.stateVersion = "24.05";
}
