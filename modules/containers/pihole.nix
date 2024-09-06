{
  lib,
  config,
  ...
}:
let
  cfg = config.pi-hole;
in
{
  imports = [ ./default.nix ];

  options = {
    pi-hole = {
      configPath = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/pihole";
      };
      image = lib.mkOption {
        type = lib.types.str;
        default = "pihole/pihole:latest";
      };
    };
  };

  config = {
    systemd.tmpfiles.rules = [ "d ${cfg.configPath} 0755 pihole pihole" ];

    virtualisation.oci-containers.backend = "podman";
    virtualisation.oci-containers.containers =
      let
        ip = "192.168.0.100";
      in
      {
        pi-hole = {
          inherit (cfg) image;

          ports = [
            "${ip}:53:53/tcp"
            "${ip}:53:53/udp"
            "3080:80"
            "30443:443"
          ];
          volumes = [
            "${cfg.configPath}/:/etc/pihole/"
            "/var/lib/dnsmasq.d:/etc/dnsmasq.d/"
          ];
          environment = {
            ServerIP = ip;
          };
          extraOptions = [
            "--cap-add=NET_ADMIN"
            "--dns=127.0.0.1"
            "--dns=1.1.1.1"
          ];

          workdir = cfg.configPath;
        };
      };

    users.users.pihole = {
      group = "pihole";
      uid = 898;
    };

    users.groups.pihole = {
      gid = 898;
    };
  };

}
