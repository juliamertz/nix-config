{ pkgs, inputs, ... }:
{
  imports = [
    ../../system/apps/sunshine.nix
    ../../system/apps/game-launchers.nix
  ];

  environment.systemPackages = with pkgs; [
    oversteer
    mangohud
    discord
    inputs.suyu.packages.x86_64-linux.suyu
  ];
}
