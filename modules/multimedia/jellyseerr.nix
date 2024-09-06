{
  lib,
  config,
  helpers,
  inputs,
  ...
}:
let
  cfg = config.jellyfin;
  unstable = helpers.getPkgs inputs.nixpkgs-unstable;
in
{
  config = {
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
      # port = 5055;
    };
    services.radarr = {
      enable = cfg.enableTorrent;
      openFirewall = true;
      group = "multimedia";
      # port = 7878
    };
    services.sonarr = {
      enable = cfg.enableTorrent;
      openFirewall = true;
      group = "multimedia";
      # port = 8989
    };
    services.jackett = {
      enable = cfg.enableTorrent;
      openFirewall = true;
      group = "multimedia";
      # port = 9117
    };
  };
}
