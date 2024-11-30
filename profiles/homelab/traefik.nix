{
  pkgs,
  lib,
  config,
  settings,
  helpers,
  ...
}:
let
  domain = "homelab.lan";
  localServices = [
    {
      name = "jellyseerr";
      subdomain = "jellyseerr";
      inherit (config.services.jellyseerr) port;
      theme = true;
    }
    {
      name = "jellyfin";
      subdomain = "jellyfin";
      inherit (config.jellyfin) port;
      theme = false;
    }
    {
      name = "adguardhome";
      subdomain = "adguard";
      inherit (config.services.adguardhome) port;
      theme = true;
    }
    {
      name = "gitea";
      subdomain = "git";
      port = config.services.gitea.settings.server.HTTP_PORT;
      theme = true;
    }
    {
      name = "qbittorrent";
      subdomain = "qbittorrent";
      inherit (config.services.qbittorrent) port;
      theme = true;
    }
    {
      name = "home-assistant";
      subdomain = "hass";
      inherit (config.home-assistant) port;
      theme = false;
    }
    {
      name = "radarr";
      subdomain = "radarr";
      inherit (config.services.radarr) port;
      theme = true;
    }
    {
      name = "sonarr";
      subdomain = "sonarr";
      inherit (config.services.sonarr) port;
      theme = true;
    }
    {
      name = "jackett";
      subdomain = "jackett";
      inherit (config.services.jackett) port;
      theme = true;
    }
    {
      name = "theme-park";
      subdomain = "themepark";
      inherit (config.services.theme-park) port;
      theme = false;
    }
  ];

  themepark = pkgs.fetchFromGitHub {
    owner = "packruler";
    repo = "traefik-themepark";
    rev = "2c9fc37dfb3e0d94efe53b3857a8da908c189d79";
    sha256 = "sha256-9JE/iSNulAVBsbcaWSEhCCDqxjkL2F8paXUWqppHFTQ=";
  };

  package = pkgs.traefik.overrideAttrs (_oldAttrs: {
    postInstall = ''
      mkdir -p $out/bin/plugins-local/src/github.com/packruler/
      cp -r ${themepark} $out/bin/plugins-local/src/github.com/packruler/traefik-themepark
    '';
  });
in
{
  config = {
    networking.firewall.allowedTCPPorts = [ 80 ];

    services.traefik = {
      enable = true;
      inherit package;

      staticConfigOptions = {
        api = {
          dashboard = true;
          insecure = true;
        };

        experimental = {
          localPlugins = {
            themepark = {
              modulename = "github.com/packruler/traefik-themepark";
            };
          };
        };

        entryPoints = {
          http.address = ":80";
          # https.address = ":443";
        };

        certificatesResolvers = {
          myresolver = {
            acme = {
              email = "test@example.com";
              storage = "acme.json";

              # Optional: Uncomment to use Let's Encrypt's staging server.
              # caServer = "https://acme-staging-v02.api.letsencrypt.org/directory";

              # Optional: Default certificates' duration is 2160 hours (90 days).
              # certificatesDuration = 2160;

              # Optional: Preferred certificate chain by issuer Common Name.
              # preferredChain = "ISRG Root X1";

              # Optional: Key type for certificates.
              # Available: "EC256", "EC384", "RSA2048", "RSA4096", "RSA8192".
              # keyType = "RSA4096";

              # Optional: Use a TLS-ALPN-01 ACME challenge.
              tlsChallenge = { };

              # Optional: Use a HTTP-01 ACME challenge.
              httpChallenge = {
                # Required: EntryPoint to use for HTTP-01 challenges.
                entryPoint = "web";
              };

              # Optional: Use a DNS-01 ACME challenge for wildcard certificates.
              dnsChallenge = {
                # Required: DNS provider used.
                provider = "digitalocean";

                # Optional: Delay before DNS challenge verification, in seconds.
                # delayBeforeCheck = 0;

                # Optional: Custom DNS resolvers.
                # resolvers = [ "1.1.1.1:53" "8.8.8.8:53" ];

                # Optional: Disable DNS propagation checks (NOT RECOMMENDED).
                # disablePropagationCheck = true;
              };
            };
          };
        };

      };

      dynamicConfigOptions = {
        http = {
          routers =
            let
              host = target: "Host(`${target}`)";
              mappedServices = map (s: {
                ${s.name} = {
                  entryPoints = [
                    "http"
                    # "https"
                  ];
                  # tls.certResolver = "myresolver";
                  rule = host "${s.subdomain}.${domain}";
                  service = s.name;
                  ${if s.theme then "middlewares" else null} = [ "${s.name}-theme" ];
                };
              }) localServices;
            in
            lib.mkMerge (
              mappedServices
              ++ [
                {
                  api = {
                    entryPoints = [ "http" ];
                    rule = "Host(`traefik.${domain}`) && (PathPrefix(`/api`) || PathPrefix(`/dashboard`))";
                    service = "api@internal";
                  };
                }
              ]
            );

          services = builtins.listToAttrs (
            map (service: {
              inherit (service) name;
              value = {
                loadBalancer.servers = [ { url = "http://127.0.0.1:${builtins.toString service.port}"; } ];
              };
            }) localServices
          );

          middlewares =
            let
              theme = app: {
                plugin.themepark = {
                  inherit app;
                  theme = "rose-pine-moon";
                  baseUrl = "http://themepark.homelab.lan";
                };
              };
            in
            {
              auth.basicAuth.users = [ "julia:$apr1$lAxApuuz$m3GaBKv94PNOlVSdqyiTT1" ];

              qbittorrent-theme = theme "qbittorrent";
              jellyfin-theme = theme "jellyfin";
              jellyseerr-theme = theme "overseerr";
              adguardhome-theme = theme "adguard";
              gitea-theme = theme "gitea";
              sonarr-theme = theme "sonarr";
              radarr-theme = theme "radarr";
              jackett-theme = theme "jackett";
            };

        };
      };
    };

    # Change working directory to source where local plugins reside
    systemd.services.traefik.serviceConfig.WorkingDirectory = "${config.services.traefik.package}/bin";
  };
}
