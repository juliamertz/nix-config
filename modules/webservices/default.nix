{ pkgs, ... }:
{
  services.traefik = {
    enable = true;

    staticConfigOptions = {
      entryPoints = {
        http = {
          address = ":80";
          # forwardedHeaders = {
          #   trustedIPs = [
          #     "127.0.0.1/32"
          #     "10.0.0.0/8"
          #     "192.168.0.0/16"
          #   ]; #
        };
      };
    };
  };

  dynamicConfigOptions = {
    http = {
      routers = {
        lightspeed-dhl-integration = {
          entryPoints = [ "https" ];
          rule = "Host(`juliamertz.dev`)";
          service = "lightspeed-dhl-integration";
        };

      };
      services = {
        lightspeed-dhl-integration.loadBalancer.servers = [ { url = "http://localhost:8000"; } ];
      };
    };
  };
}
