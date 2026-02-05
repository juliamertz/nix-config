{
  lib,
  config,
  settings,
  ...
}: let
  # specific version where radarr/sonarr/jackett don't have weird dotnet requirements.
  pkgs =
    import
    (builtins.fetchTarball {
      name = "nixpkgs-unstable-dotnet";
      url = "https://github.com/nixos/nixpkgs/archive/5e4fbfb6b3de1aa2872b76d49fafc942626e2add.tar.gz";
      sha256 = "127dk2l5fr0922an96rmlzg32vh6pxh7r6qyvkhwf20jdzg9k61r";
    })
    {
      system = settings.system.platform;
    };
in {
  config = {
    users.groups.multimedia = {};
    users.users."${settings.user.username}".extraGroups = ["multimedia"];

    systemd.tmpfiles.rules = ["d /home/media 0770 - multimedia - -"];

    services.jellyfin = {
      enable = true;
      configDir = "/home/media/jellyfin";
      openFirewall = true;
      group = "multimedia";
    };

    nixpkgs.config = {
      packageOverrides = _: {
        inherit
          (pkgs)
          jellyseerr
          radarr
          sonarr
          jackett
          ;
      };
    };

    services.jellyseerr = {
      enable = true;
      openFirewall = true;
      port = 5055;
    };
    services.radarr = {
      enable = true;
      openFirewall = true;
      group = "multimedia";
      port = 7878;
    };
    services.sonarr = {
      enable = true;
      openFirewall = true;
      group = "multimedia";
      port = 8989;
    };
    services.jackett = {
      enable = true;
      openFirewall = true;
      group = "multimedia";
      port = 9117;
    };

    reverse-proxy.services = {
      jellyfin = {
        subdomain = "jellyfin";
        port = 8096;
      };
      jellyseerr = {
        subdomain = "jellyseerr";
        port = config.services.jellyseerr.port;
        theme = true;
      };
      radarr = {
        subdomain = "radarr";
        port = config.services.radarr.port;
        theme = true;
      };
      sonarr = {
        subdomain = "sonarr";
        port = config.services.sonarr.port;
        theme = true;
      };
      jackett = {
        subdomain = "jackett";
        port = config.services.jackett.port;
        theme = true;
      };
    };
  };

  # these modules don't have a port option yet.
  options.services = with lib; {
    radarr.port = mkOption {type = types.number;};
    sonarr.port = mkOption {type = types.number;};
  };
}
