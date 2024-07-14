{ lib, config, ... }:
let 
  cfg = config.home-assistant;
  toStr = builtins.toString;
in {
  imports = [
    ./podman.nix
  ];

  options = {
    home-assistant.port = lib.mkOption {
      type = lib.types.number;
      default = 8123;
    };
  };
  config = {
    networking.firewall.allowedTCPPorts = [ cfg.port ];

    virtualisation.oci-containers.backend = "podman";
    virtualisation.oci-containers.containers = {
      home-assistant = {
        image = "docker.io/homeassistant/home-assistant:latest";
        autoStart = true;
        ports = [ "${toStr cfg.port}:${toStr cfg.port}" ];
        volumes = [
          "/home/julia/home-assistant:/config"
          "/etc/localtime:/etc/localtime:ro"
        ];
        extraOptions = [
          "--privileged"
          "--network=host"
        ];
      };
    };

    systemd.tmpfiles.rules = [
      "d /home/julia/home-assistant 0755 root root"
    ];
  };
}
