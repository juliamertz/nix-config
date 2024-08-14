{ settings, helpers, ... }:
let
  port = 9993;
  user = settings.user.username;
in {
  services.zerotierone = {
    inherit port;
    enable = true;
  };

  sops.secrets =
    helpers.ownedSecrets user [ "zerotier_network_id" "zerotier_network2_id" ];

  system.activationScripts.joinZerotierNetwork.text = # sh
    ''
      #!/bin/bash
      NETWORK_ID=$(cat /run/secrets/zerotier_network_id)
      NETWORK2_ID=$(cat /run/secrets/zerotier_network2_id)
      /run/current-system/sw/bin/zerotier-cli join $NETWORK_ID
      /run/current-system/sw/bin/zerotier-cli join $NETWORK2_ID
    '';

  networking.firewall = {
    allowedTCPPorts = [ port ];
    allowedUDPPorts = [ port ];
  };
}
