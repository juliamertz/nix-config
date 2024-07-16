{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    lutris
    # rpcs3
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };
}
