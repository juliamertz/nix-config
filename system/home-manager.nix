{ lib, settings, config, inputs, ... }:
let 
  cfg = config; 
in {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  options = {
    home.file = lib.mkOption {
      type = lib.types.attrs;
      default = {};
    };
    home.config = lib.mkOption {
      type = lib.types.attrs;
      default = {};
    };
  };

  config = {
    home-manager.users.${settings.user.username} = {
      home.file = cfg.home.file; 
      home.stateVersion = "24.05";
    } // cfg.home.config;
  };
}
