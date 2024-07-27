{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    qbittorrent
    qbittorrent-nox
  ];

  networking.firewall.allowedTCPPorts = [ 8080 ];
  networking.firewall.allowedUDPPorts = [ 8080 ];
}
