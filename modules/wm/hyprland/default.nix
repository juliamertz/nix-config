{ dotfiles, inputs, helpers, ... }:
let
  pkgs = helpers.getPkgs inputs.nixpkgs-unstable;
  hyprland = helpers.wrapPackage {
    name = "Hyprland";
    package = pkgs.hyprland;
    extraFlags = "--config ${dotfiles.path}/hypr/hyprland.conf";
    dependencies = with pkgs; [
      swaynotificationcenter
      waybar
      nvidia-vaapi-driver
      swww
      wofi
      pamixer
      playerctl
    ];
  };
in {
  environment.systemPackages = [ hyprland ];
  programs.xwayland.enable = true;
}
