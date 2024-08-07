{ pkgs, lib, config, ... }:
let
  cfg = config.qbittorrent;
in {
  options = with lib; {
    qbittorrent = {
      gui.enable = mkOption {
        type = types.bool;
        default = true;
      };
    }; 
  };

  config = {
    environment.systemPackages = with pkgs; [ qbittorrent-nox ]
      ++ lib.optionals cfg.gui.enable [ qbittorrent ];

    networking.firewall.allowedTCPPorts = [ 8080 ];
    networking.firewall.allowedUDPPorts = [ 8080 ];
  };
}
