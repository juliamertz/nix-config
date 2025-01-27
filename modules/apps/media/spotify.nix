{
  inputs,
  settings,
  helpers,
  dotfiles,
  ...
}:
let
  inherit (settings.user) username;
  pkgs = import inputs.nixpkgs-24_05 {
    system = settings.system.platform;
    config.allowUnfree = true;
  };
in
{
  sops.secrets = helpers.ownedSecrets username [ "spotify_client_id" ];
  environment.systemPackages = [
    dotfiles.pkgs.spotify-player
    pkgs.spotify
  ];
}
