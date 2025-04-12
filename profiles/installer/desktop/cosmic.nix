{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [
    ../base/installer-desktop.nix
    ../base/graphical.nix

    # build from personal configuration
    # requires home-manager to set preferences
    ../../workstation/cosmic-desktop
  ];

  isoImage.edition = lib.mkDefault "cosmic";

  cosmic-desktop = {
    enable = true;
    configForUser = "nixos";
  };

  installer-desktop.enable = false;

  # Use SDDM for autologin as cosmic-greeter does not formally support this yet
  services.displayManager = {
    sddm.enable = true;
    autoLogin = {
      enable = true;
      user = "nixos";
    };
  };
}
