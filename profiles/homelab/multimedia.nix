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
  unstable = helpers.getPkgs inputs.nixpkgs-unstable;
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
        inherit (unstable)
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
    jackett.port = mkOption { type = types.number; };
  };
}
