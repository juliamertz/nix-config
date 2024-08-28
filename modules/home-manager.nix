{ lib, settings, config, inputs, helpers, ... }:
let cfg = config.home;
in {
  imports = [ ] ++ lib.optionals helpers.isLinux
    [ inputs.home-manager.nixosModules.home-manager ]
    ++ lib.optionals helpers.isDarwin
    [ inputs.home-manager.darwinModules.home-manager ];

  options = {
    home.file = lib.mkOption {
      type = lib.types.attrs;
      default = { };
    };
    home.config = lib.mkOption {
      type = lib.types.attrs;
      default = { };
    };
    home.activation = lib.mkOption {
      type = lib.types.attrs;
      default = { };
    };
    home.programs = lib.mkOption {
      type = lib.types.attrs;
      default = { };
    };
  };

  config = {
    home-manager.users.${settings.user.username} = {
      home = {
        inherit (cfg) file activation;
        stateVersion = "24.05";
      };

      inherit (cfg) programs;
    } // cfg.config;
  };
}
