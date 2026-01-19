{
  pkgs,
  lib,
  inputs,
  ...
}: let
  sddm-rose-pine = inputs.nur.packages.${pkgs.stdenv.hostPlatform.system}.sddm-rose-pine;
in {
  environment.systemPackages = [sddm-rose-pine];

  services.displayManager = {
    defaultSession = "none+awesome";
    sddm = {
      enable = true;
      theme = "rose-pine";
      extraPackages = [sddm-rose-pine];
    };
  };

  services.xserver.displayManager.setupCommands =
    # bash
    ''
      # turn off left monitor
      ${lib.getExe pkgs.xorg.xrandr} --output HDMI-0 --off
    '';
}
