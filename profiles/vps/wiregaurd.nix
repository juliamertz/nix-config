{
  pkgs,
  lib,
  settings,
  config,
  ...
}:
let
  cfg = config.wireguard;
in
{
  options.wireguard = with lib; {
    port = mkOption {
      type = types.number;
      default = 51820;
    };
    serverIP = mkOption {
      type = types.str;
      default = "10.100.0.1";
    };
    clientIP = mkOption {
      type = types.str;
      default = "10.100.0.2";
    };
  };

  config = {
    networking.nat.enable = true;
    networking.nat.externalInterface = "enp1s0";
    networking.nat.internalInterfaces = [ "wg0" ];
    networking.firewall.allowedUDPPorts = [ cfg.port ];

    networking.wireguard.enable = true;
    networking.wireguard.interfaces = {
      wg0 = {
        ips = [ "${cfg.serverIP}/24" ];
        listenPort = cfg.port;
        privateKeyFile = "${settings.user.home}/wireguard/private";
        peers = [
          {
            publicKey = "VcEu1t2j+mmiPKI8NBusFp1Qgi/VhblZencgsM4qWwo=";
            allowedIPs = [ "${cfg.clientIP}/32" ];
          }
        ];
      };
    };
  };
}
