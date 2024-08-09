{ pkgs, lib, ... }:
let rose-pine-sddm = pkgs.libsForQt5.callPackage ./sddm-rose-pine.nix { };
in {
  environment.systemPackages = [ rose-pine-sddm ];

  services.xserver.displayManager.sddm.theme = "rose-pine";
  services.xserver.displayManager.setupCommands = # bash
    ''
      ${lib.getExe pkgs.xorg.xrandr} --output HDMI-0 --off
    '';
  services.displayManager = {
    sddm.enable = true;
    defaultSession = "none+awesome";
  };
}
