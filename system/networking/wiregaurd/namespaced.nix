
{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [ wireguard-tools ];

  systemd.services."netns@" = {
    description = "%I network namespace";
    before = [ "network.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.iproute}/bin/ip netns add %I";
      ExecStop = "${pkgs.iproute}/bin/ip netns del %I";
    };
  };

  systemd.services.wg = let ip = "10.75.130.74/32";
  in {
    description = "wg network interface";
    bindsTo = [ "netns@wg.service" ];
    requires = [ "network-online.target" ];
    after = [ "netns@wg.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = let
        iproute = "${pkgs.iproute}/bin/ip";
        wg = "${pkgs.wireguard-tools}/bin/wg";
      in pkgs.writers.writeBash "wg-up" ''
        set -e
        ${iproute} link add wg0 type wireguard
        ${iproute} link set wg0 netns wg
        ${iproute} -n wg address add <ipv4 VPN addr/cidr> dev wg0
        ${iproute} netns exec wg \
          ${wg} setconf wg0 /home/julia/Downloads/wg-NL-366.conf
        ${iproute} -n wg link set wg0 up
        ${iproute} -n wg route add default dev wg0
      '';
      ExecStop = with pkgs;
        writers.writeBash "wg-down" ''
          ${iproute} -n wg route del default dev wg0
          ${iproute} -n wg link del wg0
        '';
    };
  };
}

