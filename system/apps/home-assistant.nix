{ lib, config, settings, ... }:
let 
  cfg = config.home-assistant;
  toStr = builtins.toString;
in {
  imports = [
    ./podman.nix
  ];

  options = {
    home-assistant = {
      tag = lib.mkOption {
        type = lib.types.str;
        default = "latest"; # stable / latest / beta
      };
      port = lib.mkOption {
        type = lib.types.number;
        default = 8123;
      };
      configPath = lib.mkOption {
        type = lib.types.str;
        default = "/home/${config.user.username}/home-assistant";
      };
    };
  };
  config = {
    networking.firewall.allowedTCPPorts = [ cfg.port ];

    virtualisation.oci-containers.backend = "podman";
    virtualisation.oci-containers.containers = {
      home-assistant = {
        image = "docker.io/homeassistant/home-assistant:${cfg.tag}";
        autoStart = true;
        ports = [ "${toStr cfg.port}:${toStr cfg.port}" ];
        volumes = [
          "${cfg.configPath}:/config"
          "/etc/localtime:/etc/localtime:ro"
        ];
        extraOptions = [
          "--privileged"
          "--network=host"
        ];
      };
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.configPath} 0755 root root"
    ];
  };
}
