{
  pkgs,
  lib,
  inputs,
  ...
}: {
  environment.systemPackages = [
    inputs.nur.packages.${pkgs.stdenv.hostPlatform.system}.sddm-rose-pine
  ];

  services.displayManager = {
    defaultSession = "none+awesome";
    sddm = {
      enable = true;
      theme = "rose-pine";
      setupScript =
        # bash
        ''
          # turn off left monitor
          ${lib.getExe pkgs.xorg.xrandr} --output HDMI-0 --off
        '';
    };
  };
}
