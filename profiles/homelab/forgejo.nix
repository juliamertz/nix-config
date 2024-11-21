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
  services.forgejo = {
    enable = true;
    database.type = "postgres";
    lfs.enable = true;
    settings = {
      server = {
        HTTP_PORT = 3000;
        DOMAIN = "git.homelab.lan";
        ROOT_URL = "https://git.homelab.lan/";
      };
      service.DISABLE_REGISTRATION = true;
      # actions = {
      #   ENABLED = true;
      #   DEFAULT_ACTIONS_URL = "github";
      # };
    };
  };
}
