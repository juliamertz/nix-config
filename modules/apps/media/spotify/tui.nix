{
  pkgs,
  inputs,
  dotfiles,
  helpers,
  settings,
  ...
}:
let
  inherit (settings.user) username;

  package = inputs.spotify-player.packages.${pkgs.system}.default;
  overlay = package.overrideAttrs (_: {
    buildNoDefaultFeatures = true;
    cargoBuildFeatures = [
      "daemon"
      "image"
      "alsa-backend"
      "fzf"
      "streaming"
      "media-control"
    ];
  });

  wrapped = helpers.wrapPackage {
    package = overlay;
    name = "spotify_player";
    extraFlags = "--config-folder ${dotfiles.path}/spotify-player";
    postWrap = # sh
      ''
        ln -sf $out/bin/spotify_player $out/bin/spt
      '';
  };
in
{
  environment.systemPackages = [ wrapped ];
  sops.secrets = helpers.ownedSecrets username [ "spotify_client_id" ];
}
