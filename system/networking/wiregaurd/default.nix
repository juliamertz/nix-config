{ pkgs, settings, helpers, ... }:
let user = settings.user.username;
in {
  networking.wg-quick.interfaces = {
    wg0 = let ip = "10.75.130.74/32";
    in {
      # ips = [ "10.75.130.74/32" ];
      address = [ ip ];
      listenPort = 51820;
      privateKeyFile = "/run/secrets/protonvpn_wiregaurd_private_key";

      # postUp = ''
      #   ${pkgs.iptables}/bin/iptables -A FORWARD -i wg0 -j ACCEPT
      #   ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s ${ip} -o eth0 -j MASQUERADE
      # '';
      # preDown = ''
      #   ${pkgs.iptables}/bin/iptables -D FORWARD -i wg0 -j ACCEPT
      #   ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s ${ip} -o eth0 -j MASQUERADE
      # '';

      peers = [{
        publicKey = "oVHQPMeCCfPpGhPjEKAFG94wrSmn5MR/kGOThxcefVU=";
        allowedIPs = [
          # "0.0.0.0/0" 
        ];
        endpoint = "190.2.132.139:51820";
        # persistentKeepalive = 25;
      }];
    };
  };

  sops.secrets =
    helpers.ownedSecrets user [ "protonvpn_wiregaurd_private_key" ];
}
