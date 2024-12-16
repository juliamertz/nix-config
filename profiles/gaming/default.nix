{ pkgs, ... }:
{
  imports = [
    # ./wheel.nix

    ../../modules/apps/sunshine.nix
    ../../modules/apps/game-launchers.nix
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
