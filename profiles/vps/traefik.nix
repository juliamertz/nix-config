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
            storage = "acme.json";

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
            jellyfin.loadBalancer.servers = [ { url = "http://${wg.clientIP}:8096"; } ];
            jellyseerr.loadBalancer.servers = [ { url = "http://${wg.clientIP}:5055"; } ];
          };

          middlewares = {
            auth.basicAuth.users = [ "julia:$apr1$lAxApuuz$m3GaBKv94PNOlVSdqyiTT1" ];
          };
        };
      };
    };
  };
}
