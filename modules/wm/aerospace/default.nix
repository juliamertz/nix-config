{
  lib,
  dotfiles,
  ...
}: let
  package = dotfiles.pkgs.aerospace;
in {
  environment.systemPackages = [package];

  launchd.user.agents.aerospace = {
    command = "${package}/Applications/AeroSpace.app/Contents/MacOS/AeroSpace";
    serviceConfig = {
      KeepAlive = true;
      RunAtLoad = true;
    };
  };

  system.defaults = {
    dock.expose-group-apps = true;
    spaces.spans-displays = false;
  };
}
