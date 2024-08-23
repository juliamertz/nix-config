{ lib, pkgs, config, settings, ... }:
let cfg = config.sponsorblock-atv;
in {
  imports = [ ./default.nix ];

  options = {
    sponsorblock-atv = {
      configPath = lib.mkOption {
        type = lib.types.path;
        default = "${settings.user.home}/sponsorblock-atv";
      };
      image = lib.mkOption {
        type = lib.types.str;
        default = "ghcr.io/dmunozv04/isponsorblocktv";
      };
    };
  };

  config = {
    systemd.tmpfiles.rules = let user = settings.user.username;
    in [ "d ${cfg.configPath} 0755 ${user} ${user}" ];

    environment.systemPackages = [
      (pkgs.writeShellScriptBin "sponsorblock-setup"
        "sudo podman run --rm -it -v ${cfg.configPath}:/app/data ${cfg.image} --setup-cli")
    ];

    virtualisation.oci-containers.backend = "podman";
    virtualisation.oci-containers.containers = {
      sponsorblock-atv = {
        inherit (cfg) image;
        autoStart = true;
        volumes = [ "${cfg.configPath}:/app/data" ];
        extraOptions = [ "--network=host" ];
      };
    };
  };
}
