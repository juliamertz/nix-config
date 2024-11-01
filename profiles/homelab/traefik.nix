{ pkgs, config, ... }:
let
  domain = "homelab.lan";

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
      };
    };

    dynamicConfigOptions = {
      http = {
        routers =
          let
            host = target: "Host(`${target}`)";
            entryPoints = [ "http" ];
          in
          {
            api = {
              inherit entryPoints;
              rule = "Host(`traefik.${domain}`) && (PathPrefix(`/api`) || PathPrefix(`/dashboard`))";
              service = "api@internal";
            };

            home-assistant = {
              inherit entryPoints;
              rule = host "hass.${domain}";
              service = "home-assistant";
            };

            adguard = {
              inherit entryPoints;
              rule = host "adguard.${domain}";
              service = "adguard";
              middlewares = [ "adguard-theme" ];
            };

            qbittorrent = {
              inherit entryPoints;
              rule = host "qbittorrent.${domain}";
              service = "qbittorrent";
              middlewares = [ "qbittorrent-theme" ];
            };

            jellyfin = {
              inherit entryPoints;
              rule = host "jellyfin.${domain}";
              service = "jellyfin";
              middlewares = [ "jellyfin-theme" ];
            };

            jellyseerr = {
              inherit entryPoints;
              rule = host "jellyseerr.${domain}";
              service = "jellyseerr";
            };
          };

        services =
          let
            toStr = builtins.toString;
            mkService = port: { loadBalancer.servers = [ ({ url = "http://127.0.0.1:${toStr port}"; }) ]; };
          in
          with config;
          {
            home-assistant = mkService home-assistant.port;
            qbittorrent = mkService services.qbittorrent.port;
            adguard = mkService services.adguardhome.port;
            jellyfin = mkService jellyfin.port;
            jellyseerr = mkService 5055;
          };

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
          adguard-theme.plugin.themepark = {
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
