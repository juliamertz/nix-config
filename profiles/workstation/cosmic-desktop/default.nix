{
  lib,
  config,
  inputs,
  settings,
  ...
}:
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

    configForUser = mkOption {
      type = types.str;
      default = settings.user.username;
    };
  };

  config = {
    services.desktopManager.cosmic.enable = cfg.enable;

    nix.settings = {
      substituters = [ "https://cosmic.cachix.org/" ];
      trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
    };

    home-manager.users.${cfg.configForUser} = {
      imports = [
        (import ./home.nix inputs)
        inputs.cosmic-manager.homeManagerModules.cosmic-manager
      ];
    };
  };
}
