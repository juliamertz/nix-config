{ lib, config, inputs, helpers, ... }:
let
  cfg = config.services.qbittorrent;
  pkgs = (helpers.getPkgs inputs.nixpkgs-unstable);
in with lib; {
  options = {
    services.qbittorrent.flood = {
      enable = mkEnableOption (lib.mdDoc "Flood bittorrent webui");

      port = mkOption {
        type = types.port;
        default = 8282;
        description = lib.mdDoc ''
          Flood web UI port.
        '';
      };

      host = mkOption {
        type = types.str;
        default = "0.0.0.0";
        description = lib.mdDoc ''
          The host that Flood should listen for web connections on
        '';
      };
    };
  };

  config = let
    port = cfg.flood.port;
    host = cfg.flood.host;
    toStr = builtins.toString;
  in mkIf cfg.flood.enable {
    environment.systemPackages = with pkgs; [ flood ];

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ port ];
      allowedUDPPorts = [ port ];
    };

    systemd.services.flood = {
      description = "Flood service";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      requires = [ "network-online.target" ];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;

        ExecStart = # sh
          ''
            ${pkgs.flood}/bin/flood \
              --port ${toStr port} \
              --host ${host}
              # --qburl "http://${host}:${toStr cfg.port}"
          '';
      };
    };

  };
}
