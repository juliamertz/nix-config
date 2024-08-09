{ config, lib, pkgs, helpers, settings, inputs, ... }:
with lib;
let cfg = config.services.qbittorrent;
in {
  options.services.qbittorrent = {
    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/qbittorrent";
      description = lib.mdDoc ''
        The directory where qBittorrent stores its data files.
      '';
    };

    port = mkOption {
      type = types.port;
      default = 8280;
      description = lib.mdDoc ''
        qBittorrent web UI port.
      '';
    };
  };

  config = {
    networking.firewall.allowedTCPPorts = [ cfg.port ];
    networking.firewall.allowedUDPPorts = [ cfg.port ];

    systemd.services.qbittorrent = {
      description = "qBittorrent-nox service";
      documentation = [ "man:qbittorrent-nox(1)" ];
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      requires = [ "network-online.target" ];

      serviceConfig = {
        Type = "simple";
        User = "qbittorrent";
        Group = "qbittorrent";

        ExecStart = "${pkgs.qbittorrent-nox}/bin/qbittorrent-nox";
        ExecStartPre = let
          preStartScript = pkgs.writeScript "qbittorrent-run-prestart" # sh
            ''
              #!${pkgs.bash}/bin/bash
              if ! test -d "$QBT_PROFILE"; then
                echo "Creating initial qBittorrent data directory in: $QBT_PROFILE"
                install -d -m 0755 -o "qbittorrent" -g "qbittorrent" "$QBT_PROFILE"
              fi
            '';
        in "!${preStartScript}";
      };

      environment = {
        QBT_PROFILE = cfg.dataDir;
        QBT_WEBUI_PORT = toString cfg.port;
      };
    };

    users.groups.qbittorrent = { gid = 888; };
    users.users.qbittorrent = {
      group = "qbittorrent";
      uid = 888;
    };
  };
}
