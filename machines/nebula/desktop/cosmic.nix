{
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ../base/installer-desktop.nix
    ../base/graphical.nix
  ];

  isoImage.edition = lib.mkDefault "cosmic";

  home-manager.users.nixos = {
    imports = [
      inputs.cosmic-manager.homeManagerModules.cosmic-manager
      ../../../home/julia/cosmic.nix
    ];
  };

  services.desktopManager.cosmic.enable = true;

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
