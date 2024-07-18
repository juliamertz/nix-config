{ settings, pkgs, lib, config, ... }:
let 
  cfg = config.openvpn;
  protonvpn = pkgs.callPackage ./proton.nix { };
  ifProfile = profile: val: lib.mkIf ( cfg.proton.enable && cfg.proton.profile == profile ) val;
in {
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
      nl-393-protonvpn = ifProfile "nl-protonvpn" (protonvpn.mkConfig "212.92.104.209");
      de-200-protonvpn = ifProfile "de-protonvpn" (protonvpn.mkConfig "217.138.216.130");
    };

    sops.secrets = {
      openvpn_auth = { owner = settings.user.username; };
      openvpn_ca = { owner = settings.user.username; };
      openvpn_tls_crypt = { owner = settings.user.username; };
    };

    environment.systemPackages = with pkgs; [
      networkmanager-openvpn 
      openvpn
    ];
  };
}

