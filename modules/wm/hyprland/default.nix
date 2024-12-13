{
  dotfiles,
  inputs,
  helpers,
  ...
}:
let
  pkgs = helpers.getPkgs inputs.nixpkgs-24_11;
in
# dependencies = ;
# hyprland = helpers.wrapPackage {
#   name = "Hyprland";
#   package = pkgs.hyprland;
#   extraFlags = "--config ${dotfiles.path}/hypr/hyprland.conf";
#   dependencies = with pkgs; [ nvidia-vaapi-driver ] ++ dependencies;
# };
{
  environment.systemPackages = with pkgs; [
    swaynotificationcenter
    waybar
    swww
    wofi
    pamixer
    playerctl
    nvidia-vaapi-driver
    kitty
  ];
  programs.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    xwayland.enable = true;
  };
}
