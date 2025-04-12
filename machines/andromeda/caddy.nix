{
  lib,
  config,
  ...
}: let
  cfg = config.services.caddy;
in {
  imports = [
    ./services/blog.nix
    ./services/valnetten.nix
  ];

  options.services.caddy = with lib; {
    domain = mkOption {
      type = types.nonEmptyStr;
      default = "";
    };
  };

  config = {
    networking.firewall.allowedTCPPorts = [
      80
      443
    ];

    services.caddy = {
      enable = true;
      domain = "juliamertz.dev";
      virtualHosts = {
        "watch.${cfg.domain}".extraConfig = ''
          reverse_proxy http://10.100.0.2:8096
        '';
      };
    };
  };
}
