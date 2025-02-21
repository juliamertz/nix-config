{ pkgs, ... }:
{
  imports = [
    ./sunshine.nix
    ./launchers.nix
    # ./wheel.nix
  ];

  environment.systemPackages = with pkgs; [
    protontricks
    mangohud
    discord
    wine
    winetricks
    prismlauncher
    # inputs.suyu.packages.x86_64-linux.suyu
  ];
}
