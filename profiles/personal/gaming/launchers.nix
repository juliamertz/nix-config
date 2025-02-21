{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    lutris
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };
}
