{ pkgs, ... }:
{
  imports = [
    ./valnetten.nix
  ];

  # networking.firewall.allowedTCPPorts = [ 8080 ];

  services.traefik = {
    enable = true;
    package = pkgs.traefik;

    staticConfigOptions = {
      api = {
        dashboard = true;
        insecure = true;
      };

      entryPoints = {
        http.address = ":80";
      };
    };

    dynamicConfigOptions = {
      http = {

        routers = {
          api = {
            rule = "Host(`traefik.docker.localhost`)";
            entryPoints = [ "http" ];
            service = "api@internal";
          };
        };
      };
    };
  };
}
