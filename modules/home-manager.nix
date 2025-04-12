{
  lib,
  settings,
  config,
  inputs,
  helpers,
  ...
}: let
  cfg = config.home;
  module =
    if helpers.isLinux
    then "nixosModules"
    else "darwinModules";
in {
  imports = [
    inputs.home-manager.${module}.home-manager
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
    home.activation = lib.mkOption {
      type = lib.types.attrs;
      default = {};
    };
    home.programs = lib.mkOption {
      type = lib.types.attrs;
      default = {};
    };
  };

  config = {
    home-manager = {
      extraSpecialArgs = {inherit inputs helpers;};
      users.${settings.user.username} =
        {
          home = {
            inherit (cfg) file activation;
            stateVersion = "24.05";
          };

          inherit (cfg) programs;
        }
        // cfg.config;
    };
  };
}
