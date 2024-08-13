{ lib, cfg }:
let
  concat = builtins.concatStringsSep;
  serializeRemote = ip: port: "remote ${ip} ${toString port}";
  serializeRemotes = ip: ports:
    concat "\n" (map (port: serializeRemote ip port) ports);

  defaultPorts = ip: serializeRemotes ip [ 51820 1194 4569 80 5060 ];
in {
  inherit defaultPorts;
  inherit serializeRemote;
  inherit serializeRemotes;
  mkConfig = { ip, name }: {
    autoStart = (name == cfg.profile) && cfg.enable;
    updateResolvConf = true;
    config = # sh
      ''
        client
        dev tun
        proto udp

        ${defaultPorts ip}

        remote-random
        resolv-retry infinite
        nobind

        cipher AES-256-GCM

        setenv CLIENT_CERT 0
        tun-mtu 1500
        mssfix 0
        persist-key
        persist-tun

        reneg-sec 0

        remote-cert-tls server

        ca /run/secrets/openvpn_ca
        tls-crypt /run/secrets/openvpn_tls_crypt
        auth-user-pass /run/secrets/openvpn_auth

        script-security 2
      '';
        # pull-filter ignore redirect-gateway
  };
}
