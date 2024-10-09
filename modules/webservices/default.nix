{ pkgs, settings, ... }:
{
  imports = [ ./valnetten.nix ];

  # networking.firewall.allowedTCPPorts = [ 8080 ];

  services.traefik = {
    enable = true;
    package = pkgs.traefik;

    staticConfigOptions = {
      api = {
        dashboard = true;
      };
      # experimental:
      #   plugins:
      #     themepark:
      #       modulename: "github.com/packruler/traefik-themepark"
      #       version: "v1.2.0"
      experimental = {
        plugins = {
          themepark = {
            modulename = "github.com/packruler/traefik-themepark";
            version = "v1.2.0";
          };
        };
      };

      entryPoints = {
        http.address = ":80";
        https.address = ":443";
      };

      certificatesResolvers = {
        # httpChallenge.entryPoint = "web";
        letsencrypt = {
          acme = {
            email = settings.user.email;
            storage = "acme.json";
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
        };

        middlewares = {
          auth.basicAuth.users = [ "julia:$apr1$lAxApuuz$m3GaBKv94PNOlVSdqyiTT1" ];
        };

      };
    };
  };
}
