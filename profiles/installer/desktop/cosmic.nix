{ lib, inputs, ... }:
{
  imports = [
    ../base/installer-desktop.nix
    ../base/graphical.nix
    inputs.cosmic.nixosModules.default
  ];

  installer-desktop.enable = true;

  isoImage.edition = lib.mkDefault "cosmic";

  nix.settings = {
    substituters = [ "https://cosmic.cachix.org/" ];
    trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
  };

  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;

  services.displayManager.autoLogin = {
    enable = true;
    user = "nixos";
  };
}
