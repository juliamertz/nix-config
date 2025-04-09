{ lib, config, inputs, ... }:
let
  cfg = config.cosmic-desktop;
in
{
  imports = [ inputs.cosmic.nixosModules.default ];

  options.cosmic-desktop = with lib; {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = {
    services.desktopManager.cosmic.enable = cfg.enable;

    nix.settings = {
      substituters = [ "https://cosmic.cachix.org/" ];
      trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
    };
  };
}
