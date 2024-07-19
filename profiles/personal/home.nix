{ pkgs, settings, ... }:
let 
  user = settings.user.username;
  homeDir = settings.user.home;
in
{
  home.username = user;
  home.homeDirectory = homeDir;

  programs.home-manager.enable = true;

  imports = [
    # Apps
    ../../user/app/shell/bash.nix
    # ../../user/app/editor/affinity
    ../../user/dotfiles.nix
    ../../user/wm/awesome/home.nix
  ];

  dotfiles = {
    local = {
      enable = true;
      path = settings.user.dotfiles;
    };
  };
  
  nixpkgs.config.allowUnfree = true;

  # affinity = {
  #   prefix = "${homeDir}/affinity/prefix";
  #   licenseViolations = "${homeDir}/affinity/license_violations";
  #
  #   photo.enable = true;
  #   designer.enable = true;
  #   publisher.enable = true;
  # };

  home.packages = [
    (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  home.sessionVariables = {
    EDITOR = settings.user.editor; 
  };

  home.stateVersion = "24.05";
}
