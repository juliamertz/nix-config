{pkgs, settings, ... }: {
  networking.nat.enable = true;
  networking.nat.externalInterface = "enp1s0";
  networking.nat.internalInterfaces = [ "wg0" ];
  networking.firewall = {
    allowedUDPPorts = [ 51820 ];
  };

  networking.wireguard.enable = true;
  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.100.0.1/24" ];
      listenPort = 51820;
      privateKeyFile = "${settings.user.home}/wireguard/private";
      peers = [
        {
          publicKey = "VcEu1t2j+mmiPKI8NBusFp1Qgi/VhblZencgsM4qWwo=";
          allowedIPs = [ "10.100.0.2/32" ];
        }
      ];
    };
  };
}
