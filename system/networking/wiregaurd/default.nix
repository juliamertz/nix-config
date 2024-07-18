{ settings, ... }: {
  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.75.130.74/32" ];
      listenPort = 51820;
      privateKeyFile = "/run/secrets/protonvpn_key";

      peers = [{
        publicKey = "oVHQPMeCCfPpGhPjEKAFG94wrSmn5MR/kGOThxcefVU=";
        allowedIPs = [ "0.0.0.0/0" ];
        endpoint = "190.2.132.139:51820";
        persistentKeepalive = 25;
      }];
    };
  };

  sops.secrets = {
    protonvpn_key = { owner = settings.user.username; };
  };
}

