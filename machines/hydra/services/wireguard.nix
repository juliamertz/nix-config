{settings, ...}: let
  listenPort = 51820;
in {
  networking.firewall.allowedUDPPorts = [listenPort];

  networking.wg-quick.interfaces = {
    wg0 = {
      address = ["10.100.1.1/23"];
      privateKeyFile = "${settings.user.home}/wireguard/private";

      peers = [
        {
          publicKey = "+UMRNrDpies7uCO4wCgxKdyDuN1/FpmIilO8/NO66Uo=";
          allowedIPs = ["10.100.0.0/23"];
          endpoint = "wg.juliamertz.nl:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
