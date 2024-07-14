{ pkgs, settings, ... }:
let
  tokyo-night-sddm = pkgs.libsForQt5.callPackage ../../pkgs/sddm-tokyo-night.nix { };
in {
  environment.systemPackages = [ tokyo-night-sddm ];

  services.xserver.displayManager.sddm.theme = "tokyo-night-sddm";
  services.xserver.displayManager.setupCommands = /*bash*/''
    xrandr --output HDMI-0 --off
  '';
  services.displayManager = {
    sddm.enable = true;
    defaultSession = "none+${settings.user.windowManager}";
  };
}
