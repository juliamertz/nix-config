{ config, pkgs, ... }:
{
  # imports = [
  #   ../widgets/wofi
  # ];

  environment.systemPackages = with pkgs; [
    waybar
    nvidia-vaapi-driver
    swww
  ];
  # home.file.".config/hypr" = {
  #   source = "${config.dotfiles.path}/hypr";
  #   # recursive = true;
  # };

  home.file.".config/waybar" = {
    source = "${config.dotfiles.path}/waybar";
    # recursive = true;
  };
}
