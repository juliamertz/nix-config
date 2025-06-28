{
  lib,
  config,
  ...
}: let
  cfg = config.k3s;
in {
  options.k3s = with lib; {
    enable = mkEnableOption "Enable K3S service";

    openFirewall = mkEnableOption "Open ports";

    role = mkOption {
      type = types.enum ["agent" "server"];
      default = null;
    };

    sopsFile = mkOption {
      type = types.path;
      default = null;
    };

    serverAddrs = {
      type = types.listOf types.str;
      default = [];
    };

    # user = mkOption {
    #   type = types.str;
    #   default = "kubernetes";
    # };
    # group = mkOption {
    #   type = types.str;
    #   default = "kubernetes";
    # };
  };

  config = lib.mkIf cfg.enable {
    # users.groups.${cfg.group} = {};
    # users.users =
    #   {
    #     ${cfg.user} = {
    #       inherit (cfg) group;
    #       isSystemUser = true;
    #     };
    #   }
    #   // lib.genAttrs cfg.extraUsers (_: {extraGroups = [cfg.group];});

    sops.secrets = lib.genAttrs ["token"] (key: {
      owner = "julia";
      sopsFile = cfg.sopsFile;
      inherit key;
    });

    sops.templates."k3s-token" = {
      owner = "julia";
      restartUnits = ["k3s.service"];
      content = with config.sops.placeholder; ''${token}'';
    };

    services.k3s =
      {
        enable = true;
        inherit (cfg) role;
      }
      // (lib.optionalAttrs (cfg.role == "agent") {
        serverAddr = "https://192.168.0.100:6443";
        tokenFile = config.sops.templates.k3s-token.path;
        gracefulNodeShutdown = {
          enable = true;
          shutdownGracePeriod = "1m30s";
        };
      })
      // (lib.optionalAttrs (cfg.role == "server") {
        extraFlags =
          [
            "--write-kubeconfig-mode 644"
            "--tls-san 10.100.1.1"
            "--tls-san 192.168.0.100"
            "--embedded-registry"
            "--disable traefik"
          ]
          |> toString;
      });

    networking.firewall.allowedTCPPorts = lib.optionals cfg.openFirewall [
      6443 # Kubernetes API
      10250 # Metrics server
    ];
  };
}
