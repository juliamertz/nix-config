{
  inputs,
  settings,
  helpers,
  dotfiles,
  ...
}:
let
  pkgs = import inputs.nixpkgs-24_05 {
    system = settings.system.platform;
    config.allowUnfree = true;
  };
in
{
  # imports = [ ./tui.nix ];

  sops.secrets = helpers.ownedSecrets settings.user.username [ "spotify_client_id" ];
  environment.systemPackages = [
    dotfiles.pkgs.spotify-player
    pkgs.spotify
  ];
}
