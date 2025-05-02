{
  lib,
  config,
  ...
}: let
  cfg = config.gateway;
in {
  options.gateway = with lib; {
    lib = mkOption {
      type = types.attrs;
      default = import ./lib.nix {inherit lib;};
    };

    hostname = mkOption {
      type = types.nonEmptyStr;
      default = "";
    };

    services = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          hostname = mkOption {
            type = types.nullOr types.str;
            default = null;
          };
          subdomain = mkOption {
            type = types.nullOr types.str;
            default = null;
          };
          config = mkOption {
            type = types.nonEmptyStr;
            default = "";
          };
        };
      });
      default = {};
    };
  };

  config = {
    services.caddy = {
      enable = true;
      virtualHosts =
        cfg.services
        |> lib.mapAttrsToList (name: value: let
          hostname = if builtins.isNull value.hostname then cfg.hostname else value.hostname;
          subdomain = lib.optionalString (!builtins.isNull (value.subdomain or null)) "${value.subdomain}.";
        in {
          "${subdomain}${hostname}".extraConfig = value.config;
        })
        |> lib.mergeAttrsList;

      # virtualHosts = {
      #   "${cfg.hostname}".extraConfig = ''
      #     reverse_proxy http://10.100.0.2:8096
      #   '';
      # };
    };
  };
}
