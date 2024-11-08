{ pkgs, settings, ... }:
let
  port = 51820;
in
{
  networking.firewall.allowedUDPPorts = [ port ];
  networking.wireguard.enable = true;
  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.100.0.2/24" ];
      listenPort = port;
      privateKeyFile = "${settings.user.home}/wireguard/private";

      peers = [
        {
          publicKey = "mgQ/nNqnwBYN6gUJdxTAOzn7/9vNBH+4Hz9V6k1/YmU=";
          allowedIPs = [ "0.0.0.0/0" ];
          # TODO: route to endpoint not automatically configured
          # https://wiki.archlinux.org/index.php/WireGuard#Loop_routing
          # https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577
          endpoint = "188.245.65.183:${builtins.toString port}";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
