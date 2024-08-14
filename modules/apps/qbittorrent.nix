{ config, lib, pkgs, helpers, settings, inputs, ... }:
with lib;
let
  cfg = config.services.qbittorrent;

  alternativeWebUI = with pkgs;
    stdenv.mkDerivation {
      name = "iQbit";
      installPhase = "cp -rv $src/release $out";
      src = fetchgit {
        url = "https://github.com/ntoporcov/iQbit.git";
        hash = "sha256-UBFNJIRx/u8xJrK/rJ0//32DzG6nwSqMt3YillyDWno";
      };
    };
in {
  options.services.qbittorrent = {
    enable = mkEnableOption (lib.mdDoc "qBittorrent headless");

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

    user = mkOption {
      type = types.str;
      default = "qbittorrent";
      description = lib.mdDoc ''
        User account under which qBittorrent runs.
      '';
    };

    group = mkOption {
      type = types.str;
      default = "qbittorrent";
      description = lib.mdDoc ''
        Group under which qBittorrent runs.
      '';
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ cfg.port ];
    networking.firewall.allowedUDPPorts = [ cfg.port ];

    environment.systemPackages = [ alternativeWebUI ];

    systemd.services.qbittorrent = {
      description = "qBittorrent-nox service";
      documentation = [ "man:qbittorrent-nox(1)" ];
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      requires = [ "network-online.target" ];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;

        ExecStart = "${pkgs.qbittorrent-nox}/bin/qbittorrent-nox";
        ExecStartPre = let
          preStartScript = pkgs.writeScript "qbittorrent-run-prestart" # sh
            ''
              #!${pkgs.bash}/bin/bash
              if ! test -d "$QBT_PROFILE"; then
                echo "Creating initial qBittorrent data directory in: $QBT_PROFILE"
                install -d -m 0755 -o "${cfg.user}" -g "${cfg.group}" "$QBT_PROFILE"
              fi

              ${config.system.activationScripts.qbittorrent.text}
            '';
        in "!${preStartScript}";
      };

      environment = {
        QBT_PROFILE = cfg.dataDir;
        QBT_WEBUI_PORT = toString cfg.port;
      };
    };

    users.users = mkIf (cfg.user == "qbittorrent") {
      qbittorrent = {
        group = cfg.group;
        uid = 888;
      };
    };

    users.groups =
      mkIf (cfg.group == "qbittorrent") { qbittorrent = { gid = 888; }; };

    system.activationScripts.qbittorrent.text = let
      config = pkgs.writeText "qBittorrent.conf" ''
        [Meta]
        MigrationVersion=6

        [BitTorrent]
        Session\Port=54406
        Session\QueueingSystemEnabled=false
        Session\DefaultSavePath=${settings.user.home}/downloads
        Session\Interface=tun0
        Session\InterfaceName=tun0

        [Preferences]
        General\Locale=en
        MailNotification\req_auth=true
        WebUI\AuthSubnetWhitelist=@Invalid()
        WebUI\LocalHostAuth=false
        WebUI\Password_PBKDF2="@ByteArray(V5kcWZHn4FTxBM8IxsnsCA==:HPbgopaa1ZO199s4zmJAZfJ+gmGKUyAQMX1MjbphhHTtup80tt/FOFshUMRQnvCqAxAu31F6ziiUqpuUQCytPg==)"
        WebUI\Port=${builtins.toString cfg.port}
        WebUI\AlternativeUIEnabled=true
        WebUI\RootFolder=${alternativeWebUI}
      '';
      # sh
    in ''
      target=${cfg.dataDir}/qBittorrent/config
      mkdir -p $target
      rm -vf $target/qBittorrent.conf
      ln -svf ${config} $target/qBittorrent.conf
    '';
  };
}
