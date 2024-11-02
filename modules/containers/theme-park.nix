{
  lib,
  config,
  settings,
  ...
}:
let
  cfg = config.services.theme-park;
  toStr = builtins.toString;
in
{
  imports = [ ./default.nix ];

  options.services.theme-park = with lib; {
    enable = mkEnableOption (mdDoc "Theme park docker service");
    openFirewall = mkEnableOption (mdDoc "Open firewall ports");
    tag = mkOption {
      type = types.str;
      default = "latest"; # stable / latest / beta
    };
    port = mkOption {
      type = types.number;
      default = 5069;
    };
    uid = mkOption {
      type = types.number;
      default = 1000;
    };
    gid = mkOption {
      type = types.number;
      default = 1000;
    };
    configPath = mkOption {
      type = types.str;
      default = "/home/${settings.user.username}/theme-park";
    };
    urlBase = mkOption {
      type = types.str;
      default = "themepark";
    };

  };
  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];

    virtualisation.oci-containers.backend = "podman";
    virtualisation.oci-containers.containers = {
      theme-park = {
        image = "ghcr.io/themepark-dev/theme.park:${cfg.tag}";
        autoStart = true;
        environment = {
          PUID = builtins.toString cfg.uid;
          PGID = builtins.toString cfg.gid;
          TZ = "Europe/London";
          TP_URLBASE = cfg.urlBase;
        };
        ports = [ "${toStr cfg.port}:80" ];
        volumes = [ "${cfg.configPath}:/config" ];
      };
    };

    systemd.tmpfiles.rules = [ "d ${cfg.configPath} 0755 root root" ];
  };
}
