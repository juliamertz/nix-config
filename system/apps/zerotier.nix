{ pkgs, lib, ... }:
let 
  port = 9993;
in {
  services.zerotierone = {
    inherit port;
    enable = true;
  };

  system.activationScripts.script.text = ''
    #!/bin/bash
    NETWORK_ID=$(cat /run/secrets/zerotier_network_id)
    /run/current-system/sw/bin/zerotier-cli join $NETWORK_ID
  '';

  networking.firewall = {
    allowedTCPPorts = [ port ];
    allowedUDPPorts = [ port ];
  };
}
