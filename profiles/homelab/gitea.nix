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
  networking.firewall.allowedTCPPorts = [ 3000 ];
  services.gitea = {
    enable = true;
    package = pkgs.gitea;
  };
}
