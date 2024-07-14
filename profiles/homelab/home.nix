{ pkgs, settings, ... }:
let 
  user = settings.user.username;
in
{
  home.username = user;
  home.homeDirectory = "/home/${user}";

  programs.home-manager.enable = true;

  imports = [
    ../../user/app/tools/lazygit.nix
    ../../user/app/shell/fish.nix
    ../../user/app/shell/bash.nix
    ../../user/app/editor/nvim/home.nix
    ../../user/app/terminal/tmux.nix
    # ../../user/app/jellyfin.nix
    ../../user/app/tools/neofetch.nix
  ];

  nixpkgs.config.allowUnfree = true;

  home.sessionVariables = {
    EDITOR = settings.system.editor; 
  };

  home.stateVersion = "24.05";
}
