{settings, ...}: let
  listenPort = 51820;
in {
  networking.firewall.allowedUDPPorts = [listenPort];

  networking.wg-quick.interfaces = {
    wg0 = {
      address = ["10.100.0.1/24"];
      privateKeyFile = "${settings.user.home}/wireguard/private";

      peers = [
        {
          publicKey = "+UMRNrDpies7uCO4wCgxKdyDuN1/FpmIilO8/NO66Uo=";
          allowedIPs = ["10.100.0.0/24"];
          endpoint = "116.203.24.1:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
