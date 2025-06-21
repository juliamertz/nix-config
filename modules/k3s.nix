{
  lib,
  config,
  ...
}: let
  cfg = config.k3s;
in {
  options.k3s = with lib; {
    enable = mkEnableOption "Enable K3S server";

    server = mkEnableOption "is server or agent";

    openFirewall = mkEnableOption "Open ports";
  };

  config = lib.mkIf cfg.enable {
    services.k3s =
      if cfg.server
      then {
        enable = true;
        role = "server";
        extraFlags = toString [
          "--write-kubeconfig-mode 644"
          "--tls-san 10.100.1.1"
          "--tls-san 192.168.0.100"
        ];
      }
      else {
        enable = true;
        role = "agent";
        serverAddr = "https://192.168.0.100:6443";
        token = "K10b2b06dcec98d07f70cbf4a6f099a6cf21d7cdbbb9f2cb81dd53ed9306ea8cd23::server:6043d533a01eedb75061195017a69a8f";
      };

    networking.firewall.allowedTCPPorts = lib.optionals cfg.openFirewall [
      6443 # Kubernetes API
      10250 # Metrics server
    ];
  };
}
