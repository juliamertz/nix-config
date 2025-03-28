{
  settings,
  helpers,
  dotfiles,
  ...
}:
let
  inherit (settings.user) username;
in
{
  sops.secrets = helpers.ownedSecrets username [ "spotify_client_id" ];

  environment.systemPackages = with dotfiles.pkgs; [
    spotify-player
    spotify
  ];
}
