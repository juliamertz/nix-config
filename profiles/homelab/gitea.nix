{
  settings,
  inputs,
  helpers,
  ...
}:
let
  pkgs = helpers.getPkgs inputs.nixpkgs-unstable;
in
{
  services.gitea = {
    enable = true;
    package = pkgs.gitea;
    dataDir = "${settings.user.home}/gitea";
  };
}
