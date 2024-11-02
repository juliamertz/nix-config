{
  pkgs,
  lib,
  config,
  ...
}:
let
  domain = "homelab.lan";
  localServices = [
    {
      name = "jellyfin";
      subdomain = "jellyfin";
      port = config.jellyfin.port;
      theme = false;
    }
    {
      name = "adguardhome";
      subdomain = "adguard";
      port = config.services.adguardhome.port;
      theme = true;
    }
    {
      name = "qbittorrent";
      subdomain = "qbittorrent";
      port = config.services.qbittorrent.port;
      theme = true;
    }
    {
      name = "home-assistant";
      subdomain = "hass";
      port = config.home-assistant.port;
      theme = false;
    }
    {
      name = "jellyseerr";
      subdomain = "jellyseerr";
      port = 5055;
      theme = false;
    }
  ];

  theme-park = pkgs.fetchFromGitHub {
    owner = "packruler";
    repo = "traefik-themepark";
    rev = "2c9fc37dfb3e0d94efe53b3857a8da908c189d79";
    sha256 = "sha256-9JE/iSNulAVBsbcaWSEhCCDqxjkL2F8paXUWqppHFTQ=";
  };

  package = pkgs.traefik.overrideAttrs (oldAttrs: {
    postInstall = ''
      mkdir -p $out/bin/plugins-local/src/github.com/packruler/
      cp -r ${theme-park} $out/bin/plugins-local/src/github.com/packruler/traefik-themepark
    '';
  });
in
{
  networking.firewall.allowedTCPPorts = [ 80 ];

  services.traefik = {
    enable = true;
    inherit package;

    staticConfigOptions = {
      # log.level = "DEBUG";

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
      };
    };

    dynamicConfigOptions = {
      http = {
        routers =
          let
            host = target: "Host(`${target}`)";
            mappedServices = map (s: {
              ${s.name} = {
                entryPoints = [ "http" ];
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
            name = service.name;
            value = {
              loadBalancer.servers = [ ({ url = "http://127.0.0.1:${builtins.toString service.port}"; }) ];
            };
          }) localServices
        );

        middlewares = {
          auth.basicAuth.users = [ "julia:$apr1$lAxApuuz$m3GaBKv94PNOlVSdqyiTT1" ];

          qbittorrent-theme.plugin.themepark = {
            app = "qbittorrent";
            theme = "catppuccin-mocha";
          };
          jellyfin-theme.plugin.themepark = {
            app = "jellyfin";
            theme = "catppuccin-mocha";
          };
          adguardhome-theme.plugin.themepark = {
            app = "adguard";
            theme = "catppuccin-mocha";
          };
        };

      };
    };
  };

  # Change working directory to source where local plugins reside
  systemd.services.traefik.serviceConfig.WorkingDirectory = "${config.services.traefik.package}/bin";
}
