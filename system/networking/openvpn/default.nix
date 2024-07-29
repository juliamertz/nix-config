{ settings, pkgs, lib, config, ... }:
let proton = pkgs.callPackage ./proton.nix { cfg = config.openvpn.proton; };
in {
  imports = [ ./cli.nix ];

  options = {
    openvpn.proton = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      profile = lib.mkOption {
        type = lib.types.nonEmptyStr;
        default = "";
        description = "OpenVPN configuration name";
      };
    };
  };

  config = {
    services.openvpn.servers = {
      nl-393-protonvpn = (proton.mkConfig {
        ip = "212.92.104.209";
        name = "nl-393";
      });
      de-200-protonvpn = (proton.mkConfig {
        ip = "217.138.216.130";
        name = "de-200";
      });
    };

    sops.secrets = {
      openvpn_auth = { owner = settings.user.username; };
      openvpn_ca = { owner = settings.user.username; };
      openvpn_tls_crypt = { owner = settings.user.username; };
    };

    environment.systemPackages = with pkgs; [ networkmanager-openvpn openvpn ];
  };
}

