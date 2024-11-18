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
    stateDir = "${settings.user.home}/gitea";
  };
}
