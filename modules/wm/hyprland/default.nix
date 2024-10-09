{
  dotfiles,
  inputs,
  helpers,
  ...
}:
let
  pkgs = helpers.getPkgs inputs.nixpkgs-unstable;
  dependencies = with pkgs; [
    swaynotificationcenter
    waybar
    swww
    wofi
    pamixer
    playerctl
  ];
  hyprland = helpers.wrapPackage {
    name = "Hyprland";
    package = pkgs.hyprland;
    extraFlags = "--config ${dotfiles.path}/hypr/hyprland.conf";
    dependencies = with pkgs; [ nvidia-vaapi-driver ] ++ dependencies;
  };
in
{
  environment.systemPackages = dependencies;
  # programs.xwayland.enable = true;
  programs.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    xwayland.enable = true;
  };
}
