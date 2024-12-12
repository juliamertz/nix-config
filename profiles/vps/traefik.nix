{
  pkgs,
  settings,
  config,
  ...
}:
let
  wg = config.wireguard;
in
{
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  services.traefik = {
    enable = true;
    package = pkgs.traefik;

    staticConfigOptions = {
      log = {
        level = "DEBUG";
      };

      api = {
        dashboard = true;
      };

      entryPoints = {
        http.address = ":80";
        https.address = ":443";
      };

      certificatesResolvers = {
        # httpChallenge.entryPoint = "web";
        letsencrypt = {
          acme = {
            inherit (settings.user) email;
            # storage = "acme.json";
            storage = "${config.services.traefik.dataDir}/acme.json";

            dnsChallenge = {
              provider = "cloudflare";

              delayBeforeCheck = 0;
              resolvers = [
                "1.1.1.1:53"
                "8.8.8.8:53"
              ];

              disablePropagationCheck = true;
            };
          };
        };
      };

      dynamicConfigOptions = {
        http = {
          routers = {
            api = {
              rule = "Host(`traefik.juliamertz.dev`) && (PathPrefix(`/api`) || PathPrefix(`/dashboard`))";
              entryPoints = [ "https" ];
              service = "api@internal";
              tls.certResolver = "letsencrypt";
            };

            lightspeed-dhl = {
              rule = "Host(`nettenshop.juliamertz.dev`)";
              entryPoints = [ "http" "https" ];
              service = "nettenshop";
              tls.certResolver = "letsencrypt";
            };


            jellyfin = {
              rule = "Host(`watch.juliamertz.dev`)";
              entryPoints = [ "https" ];
              service = "jellyfin";
              tls.certResolver = "letsencrypt";
            };

            jellyseerr = {
              rule = "Host(`jellyseerr.juliamertz.dev`)";
              entryPoints = [ "https" ];
              service = "jellyseerr";
              tls.certResolver = "letsencrypt";
            };
          };

          services = {
            nettenshop.loadBalancer.servers = [ { url = "http://${wg.clientIP}:42069"; } ];
            jellyfin.loadBalancer.servers = [ { url = "http://${wg.clientIP}:8096"; } ];
            jellyseerr.loadBalancer.servers = [ { url = "http://${wg.clientIP}:5055"; } ];
          };

          middlewares = {
            auth.basicAuth.users = [ "julia:" ];
          };
        };
      };
    };
  };
}
