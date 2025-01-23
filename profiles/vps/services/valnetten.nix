{
  pkgs,
  settings,
  config,
  helpers,
  ...
}:
let
  inherit (settings.system) platform;
  inherit (pkgs) lib;
  toStr = builtins.toString;

  port = 42069;
  name = "lightspeed-dhl-adapter";

  user = "valnetten";
  group = "valnetten";

  revision = "e05387b30debe2b2fbe60c265103451c16267f3e";
  repo = "lightspeed-dhl-adapter";
  bin =
    (builtins.getFlake "github:juliamertz/${repo}/${revision}?dir=nix").packages.${platform}.default;

in
{
  systemd.services.${name} = {
    description = "${name} service";

    serviceConfig = {
      Type = "simple";
      User = user;
      Group = group;

      WorkingDirectory = "/etc/lightspeed-dhl";
      ExecStart = "${lib.getExe bin} /etc/lightspeed-dhl/config.toml";
    };
  };

  users.groups.${group}.gid = 6900;
  users.users.${user} = {
    inherit group;
    isNormalUser = true;
    uid = 6900;
  };

}
