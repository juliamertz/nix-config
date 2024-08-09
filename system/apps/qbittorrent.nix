{ config, lib, pkgs, helpers, settings, ... }:
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

    namespaceAddress = mkOption {
      type = types.str;
      default = "192.168.15.1";
      description = mdDoc ''
        The address of the veth interface connected to the vpn namespace.

        This is the address used to reach the vpn namespace from other
        namespaces connected to the linux bridge.
      '';
    };
  };

  config = {
    systemd.services.qbittorrent = {
      description = "qBittorrent-nox service";
      documentation = [ "man:qbittorrent-nox(1)" ];
      after = [ "network.target" "wg.service" ];
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

    # VPN & forwarding
    vpnnamespaces.wg = {
      enable = true;
      wireguardConfigFile = ../../secrets/wg0.conf;
      accessibleFrom = [ "192.168.0.0/24" "172.27.0.0/24" ];
      portMappings = [{
        from = cfg.port;
        to = cfg.port;
      }];
      openVPNPorts = [{
        port = cfg.port;
        protocol = "both";
      }];
    };

    systemd.services.qbittorrent.vpnconfinement = {
      enable = true;
      vpnnamespace = "wg";
    };

    services.caddy = {
      enable = true;
      extraConfig = ''
        http://0.0.0.0:8280, http://192.168.0.101:8280, http://172.27.21.207:8280 {
          reverse_proxy ${cfg.namespaceAddress}:${builtins.toString cfg.port}
        }
      '';
    };
  };
}
