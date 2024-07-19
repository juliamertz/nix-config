{ pkgs, pkgs-wrapped, ... }:
{
  environment.systemPackages = [ 
    pkgs.spotify
    pkgs-wrapped.spotify-player
  ];
}
