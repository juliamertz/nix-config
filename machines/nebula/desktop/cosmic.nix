{
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ../base/installer-desktop.nix
    ../base/graphical.nix

    inputs.cosmic.nixosModules.default
  ];

  isoImage.edition = lib.mkDefault "cosmic";

  home-manager.users.nixos = {
    imports = [
      inputs.cosmic-manager.homeManagerModules.cosmic-manager
      ../../home/julia/cosmic.nix
    ];
  };

  services.desktopManager.cosmic.enable = true;

  nix.settings = {
    substituters = ["https://cosmic.cachix.org/"];
    trusted-public-keys = ["cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="];
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
