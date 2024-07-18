{ pkgs, settings, ... }:
let 
  user = settings.user.username;
in
{
  home.username = user;
  home.homeDirectory = "/home/${user}";

  programs.home-manager.enable = true;

  imports = [
    # System
    ../../user/wm/awesome/home.nix
    ../../user/wm/picom/picom.nix
    ../../user/themes/rose-pine/home.nix
    # Apps
    ../../user/app/browser/firefox.nix
    ../../user/app/terminal/wezterm
    ../../user/app/shell/fish.nix
    ../../user/app/shell/bash.nix
    ../../user/app/editor/nvim
    ../../user/app/terminal/tmux
    ../../user/app/editor/affinity
    ../../user/app/spotify.nix
    ../../user/app/tools/neofetch.nix
    ../../user/app/tools/lazygit.nix
    ../../user/app/git.nix
    ../../user/dotfiles.nix
  ];

  dotfiles = {
    local = {
      enable = true;
      path = "${settings.user.home}/dotfiles";
    };
  };
  
  nixpkgs.config.allowUnfree = true;

  affinity = {
    prefix = "/home/${user}/affinity/prefix";
    licenseViolations = "/home/${user}/affinity/license_violations";

    photo.enable = true;
    designer.enable = true;
    publisher.enable = true;
  };

  rose-pine.variant = "moon";

  home.packages = [
    (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  home.sessionVariables = {
    EDITOR = settings.user.editor; 
  };

  home.stateVersion = "24.05";
}
