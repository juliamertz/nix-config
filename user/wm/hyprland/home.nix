{ config, pkgs, ... }:
{
  imports = [
    ../widgets/wofi
  ];

  home.packages = with pkgs; [
    swaybg
    swaynotificationcenter
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
