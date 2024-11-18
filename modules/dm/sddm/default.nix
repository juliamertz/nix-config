{ pkgs, lib, ... }:
let
  rose-pine-sddm = pkgs.libsForQt5.callPackage ./sddm-rose-pine.nix { };
in
{
  environment.systemPackages = [ rose-pine-sddm ];

  services.displayManager = {
    defaultSession = "none+awesome";
    sddm = {
      enable = true;
      theme = "rose-pine";
      setupScript = # bash
        ''
          ${lib.getExe pkgs.xorg.xrandr} --output HDMI-0 --off
        '';
    };
  };
}
