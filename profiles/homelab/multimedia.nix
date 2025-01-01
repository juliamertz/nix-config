{
  lib,
  config,
  helpers,
  settings,
  inputs,
  ...
}:
let
  cfg = config.jellyfin;
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
in
{
  imports = [ ../../modules/containers/jellyfin.nix ];

  config = {
    jellyfin =
      let
        user = settings.user.home;
      in
      {
        configDir = "${user}/jellyfin";
        volumes = [
          "/home/media/shows:/shows"
          "/home/media/movies:/movies"
          "/home/media/music:/music"
        ];
      };

    nixpkgs.config = lib.mkIf cfg.enableTorrent {
      packageOverrides = _: {
        inherit (pkgs)
          jellyseerr
          radarr
          sonarr
          jackett
          ;
      };
    };

    services.jellyseerr = {
      enable = cfg.enableTorrent;
      openFirewall = true;
      port = 5055;
    };
    services.radarr = {
      enable = cfg.enableTorrent;
      openFirewall = true;
      group = "multimedia";
      port = 7878;
    };
    services.sonarr = {
      enable = cfg.enableTorrent;
      openFirewall = true;
      group = "multimedia";
      port = 8989;
    };
    services.jackett = {
      enable = cfg.enableTorrent;
      openFirewall = true;
      group = "multimedia";
      port = 9117;
    };
  };

  # these modules don't have a port option yet.
  options.services = with lib; {
    radarr.port = mkOption { type = types.number; };
    sonarr.port = mkOption { type = types.number; };
  };
}
