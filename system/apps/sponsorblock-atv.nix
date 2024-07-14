{ lib, pkgs, config, ... }:
let 
  cfg = config.sponsorblock-atv;
  scripts = {
    setup = /*bash*/ ''
      sudo mkdir -p ${cfg.configPath}
      podman run --rm -it -v ${cfg.configPath}:/app/data ${cfg.image} --setup-cli
    ''; 
  };
in {
  imports = [
    ./podman.nix
  ];

  options = {
    sponsorblock-atv = {
      configPath = lib.mkOption {
        type = lib.types.path;
        default = /etc/sponsorblock-atv;
      };
      image = lib.mkOption {
        type = lib.types.str;
        default = "ghcr.io/dmunozv04/isponsorblocktv";
      };
    };
  };

  config = {
    environment.systemPackages = [ 
      (pkgs.writeShellScriptBin "sponsorblock-atv-setup" scripts.setup) 
    ];

    virtualisation.oci-containers.backend = "podman";
    virtualisation.oci-containers.containers = {
      sponsorblock-atv = {
        image = cfg.image;
        autoStart = true;
        volumes = [ "${cfg.configPath}:/app/data" ];
        extraOptions = [ "--network=host" ];
      };
    };
  };
}
