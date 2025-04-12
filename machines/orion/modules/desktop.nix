{
  lib,
  config,
  inputs,
  settings,
  ...
}: {
  imports = [inputs.cosmic.nixosModules.default];

  config = {
    services.desktopManager.cosmic.enable = true;

    nix.settings = {
      substituters = ["https://cosmic.cachix.org/"];
      trusted-public-keys = ["cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="];
    };

    home-manager.users.julia = {
      imports = [
        inputs.cosmic-manager.homeManagerModules.cosmic-manager
      ];
    };
  };
}
