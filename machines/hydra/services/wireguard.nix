{settings, ...}: let
  port = 51820;
in {
  networking.firewall.allowedUDPPorts = [port];
  networking.wireguard = {
    enable = true;
    interfaces = {
      wg0 = {
        ips = ["10.100.0.2/24"];
        listenPort = port;
        privateKeyFile = "${settings.user.home}/wireguard/private";

        peers = [
          {
            publicKey = "mgQ/nNqnwBYN6gUJdxTAOzn7/9vNBH+4Hz9V6k1/YmU=";
            allowedIPs = ["10.100.0.0/24"];
            endpoint = "188.245.65.183:${builtins.toString port}";
            persistentKeepalive = 25;
          }
        ];
      };
    };
  };
}
