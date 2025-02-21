{
  pkgs,
  lib,
  config,
  ...
}:
let
  domain = "homelab.lan";
  cfg = config.reverse-proxy;
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
  options.reverse-proxy = with lib; {
    services = mkOption {
      type = types.attrsOf (
        types.submodule {
          options = {
            subdomain = mkOption {
              type = types.nonEmptyStr;
              default = "";
            };
            port = mkOption {
              description = "Port where service is running";
              type = types.port;
            };
            theme = mkOption {
              description = ''
                Apply theme.park theme via proxy subfiltering

                If a boolean is given it will use the service's name to look up it's theme
                Otherwise if it is a string that will be used as the theme name
              '';
              type = types.oneOf [
                types.bool
                types.nonEmptyStr
              ];
              default = false;
            };
          };
        }
      );
    };
  };

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

        entryPoints.http.address = ":80";
      };

      dynamicConfigOptions = {
        http = {
          routers =
            lib.mapAttrs (name: service: {
              entryPoints = [ "http" ];
              rule = "Host(`${service.subdomain}.${domain}`)";
              service = name;
              middlewares =
                if builtins.isString service.theme then
                  [ "${service.theme}-theme" ]
                else
                  lib.optionals service.theme [ "${name}-theme" ];
            }) cfg.services
            // {
              api = {
                entryPoints = [ "http" ];
                rule = "Host(`traefik.${domain}`) && (PathPrefix(`/api`) || PathPrefix(`/dashboard`))";
                service = "api@internal";
              };
            };

          services = lib.mapAttrs (_: service: {
            loadBalancer.servers = [ { url = "http://127.0.0.1:${builtins.toString service.port}"; } ];
          }) cfg.services;

          middlewares =
            let
              theme = app: {
                plugin.themepark = {
                  inherit app;
                  theme = "rose-pine-moon";
                  baseUrl = "https://develop.theme-park.dev/";
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

    # Change working directory to source where plugins reside
    systemd.services.traefik.serviceConfig = {
      WorkingDirectory = "${config.services.traefik.package}/bin";
    };
  };
}
