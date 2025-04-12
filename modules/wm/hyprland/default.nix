{
  dotfiles,
  inputs,
  helpers,
  ...
}: let
  pkgs = helpers.getPkgs inputs.nixpkgs-24_11;
in {
  environment.systemPackages = with pkgs; [
    swaynotificationcenter
    waybar
    swww # widgets
    wofi
    nvidia-vaapi-driver
  ];

  programs.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    xwayland.enable = true;
  };
}
