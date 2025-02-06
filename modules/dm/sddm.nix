{ pkgs, lib, ... }:
{
  environment.systemPackages = [
    (pkgs.libsForQt5.callPackage ../../pkgs/sddm-rosepine.nix { })
  ];

  services.displayManager = {
    defaultSession = "none+awesome";
    sddm = {
      enable = true;
      theme = "rose-pine";
      setupScript = # bash
        ''
          # turn off left monitor
          ${lib.getExe pkgs.xorg.xrandr} --output HDMI-0 --off
        '';
    };
  };
}
