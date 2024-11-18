{ inputs, settings, ... }:
let
  pkgs = import inputs.nixpkgs-24_05 {
    system = settings.system.platform;
    config.allowUnfree = true;
  };
in
{
  imports = [ ./tui.nix ];

  # TODO: spicetify
  environment.systemPackages = [ pkgs.spotify ];
}
