{ pkgs, ... }:
{
  # networking.firewall.allowedTCPPorts = [ 8080 ];

  services.traefik = {
    enable = true;
    package = pkgs.traefik;

    # inherit staticConfigFile dynamicConfigFile;
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
          # lightspeed-dhl-integration = {
          #   entryPoints = [ "http" ];
          #   rule = "Host(`juliamertz.dev`)";
          #   service = "lightspeed-dhl-integration";
          # };
          api = {
            rule = "Host(`traefik.docker.localhost`)";
            entryPoints = [ "http" ];
            service = "api@internal";
          };
        };

        # services = {
        #   lightspeed-dhl-integration.loadBalancer.servers = [ { url = "http://localhost:8000"; } ];
        # };
      };
    };
  };
}
