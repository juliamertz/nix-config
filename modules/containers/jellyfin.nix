{
  lib,
  config,
  settings,
  ...
}:
let
  cfg = config.jellyfin;
  toStr = builtins.toString;
in
{
  imports = [
    ./default.nix
  ];

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
      enableTorrent = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = {
    users.groups.multimedia = { };
    users.users."${settings.user.username}".extraGroups = [ "multimedia" ];

    systemd.tmpfiles.rules = [ "d /home/media 0770 - multimedia - -" ];

    networking.firewall.allowedTCPPorts = [ cfg.port ];
    networking.firewall.allowedUDPPorts = [ cfg.port ];

    system.activationScripts.jellyfin.text = # sh
      ''
        dir=${cfg.configDir}
        if [ ! -e $dir ]; then
          mkdir -p $dir/config $dir/cache $dir/log
        fi
      '';

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
        environment = {
          JELLYFIN_LOG_DIR = "/log";
        };
        extraOptions = [ "--network=host" ];
      };
    };

  };

}
