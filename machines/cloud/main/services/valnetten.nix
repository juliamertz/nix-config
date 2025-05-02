{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (config.services.caddy) domain;
  cfg = config.services.nettenshop;

  revision = "f86b48784829cb47d40a48b4be5b5277b479f606";
  bin =
    (builtins.getFlake "github:juliamertz/lightspeed-dhl-adapter/${revision}?dir=nix")
    .packages
    .${pkgs.system}
    .default;
in {
  options.services.nettenshop = with lib; {
    serviceName = mkOption {
      type = types.str;
      default = "lightspeed-dhl-adapter";
    };
    subdomain = mkOption {
      type = types.str;
      default = "nettenshop";
    };
    configPath = mkOption {
      type = types.path;
      default = "/etc/lightspeed-dhl";
    };
    user = mkOption {
      type = types.str;
      default = "valnetten";
    };
    group = mkOption {
      type = types.str;
      default = "valnetten";
    };
  };

  config = {
    services.caddy.virtualHosts = {
      "nettenshop.${domain}".extraConfig = ''
        reverse_proxy http://127.0.0.1:42069
      '';
    };

    systemd.tmpfiles.rules = ["d ${cfg.configPath} 0755 ${cfg.user} ${cfg.group}"];

    systemd.services.${cfg.serviceName} = {
      description = "${cfg.serviceName} service";

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;

        WorkingDirectory = cfg.configPath;
        ExecStart = "${lib.getExe bin} ${cfg.configPath}/config.toml";
      };
    };

    users.groups.${cfg.group}.gid = 6900;
    users.users.${cfg.user} = {
      inherit (cfg) group;
      isNormalUser = true;
      uid = 6900;
    };
  };
}
