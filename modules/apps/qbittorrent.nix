{ config, lib, pkgs, helpers, settings, inputs, ... }:
with lib;
let
  cfg = config.services.qbittorrent;
  qbittorrentConf = let
    toString = value:
      if lib.isBool value then
        if value then "true" else "false"
      else
        builtins.toString value;

    formatSection = sectionName: sectionAttrs: ''
      [${sectionName}]
      ${lib.concatMapStringsSep "\n"
      (name: "${name}=${toString sectionAttrs.${name}}")
      (lib.attrNames sectionAttrs)}
    '';

    formatAttrset = attrs:
      lib.concatStringsSep "\n" (lib.mapAttrsToList
        (sectionName: sectionAttrs: formatSection sectionName sectionAttrs)
        attrs);
  in pkgs.writeText "qBittorrent.conf" (formatAttrset cfg.settings);

  # alternativeWebUI = with pkgs;
  #   stdenv.mkDerivation {
  #     name = "iQbit";
  #     installPhase = "cp -rv $src/release $out";
  #     src = fetchgit {
  #       url = "https://github.com/ntoporcov/iQbit.git";
  #       hash = "sha256-UBFNJIRx/u8xJrK/rJ0//32DzG6nwSqMt3YillyDWno";
  #     };
  #   };
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

    settings = mkOption {
      type = types.attrsOf types.attrs;
      default = { };
      description =
        "An attribute set with generic key names, each containing another attribute set.";
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ cfg.port ];
    networking.firewall.allowedUDPPorts = [ cfg.port ];

    # environment.systemPackages = [ alternativeWebUI ];

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

              CONFIG=$QBT_PROFILE/qBittorrent/config
              mkdir -p $CONFIG
              rm -vf $CONFIG/qBittorrent.conf
              # ln -svf ${qbittorrentConf} $CONFIG/qBittorrent.conf
              install -m 0555 -o "${cfg.user}" -g "${cfg.group}" ${qbittorrentConf} $CONFIG/qBittorrent.conf
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

  };
}
