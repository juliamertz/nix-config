{ lib, config, ... }:
let
  cfg = config.jellyfin;
  toStr = builtins.toString;
in {
  imports = [ ./default.nix ];

  options = {
    jellyfin = {
      tag = lib.mkOption {
        type = lib.types.str;
        default = "latest"; # stable / latest / beta
      };
      port = lib.mkOption {
        type = lib.types.number;
        default = 8096;
      };
      configDir = lib.mkOption {
        type = lib.types.nonEmptyStr;
        default = "";
      };
      volumes = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
      };
    };
  };

  config = {
    networking.firewall.allowedTCPPorts = [ cfg.port ];
    networking.firewall.allowedUDPPorts = [ cfg.port ];

    virtualisation.oci-containers.backend = "podman";
    virtualisation.oci-containers.containers = {
      jellyfin = {
        image = "docker.io/jellyfin/jellyfin:${cfg.tag}";
        autoStart = true;
        ports = [ "${toStr cfg.port}:${toStr cfg.port}" ];
        volumes = cfg.volumes ++ [
          "${cfg.configDir}/config:/config"
          "${cfg.configDir}/cache:/cache"
          "${cfg.configDir}/log:/log"
        ];
        environment = { JELLYFIN_LOG_DIR = "/log"; };
        extraOptions = [ "--network=host" ];
      };
    };
  };
}
