{ pkgs, ... }:
{
  imports = [ ./tui.nix ];

  # TODO: spicetify
  environment.systemPackages = [ pkgs.spotify ];
}
