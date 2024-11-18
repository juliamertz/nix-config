{
  dotfiles,
  # pkgs,
  inputs,
  settings,
  helpers,
  ...
}:
let
  picom = helpers.wrapPackage {
    name = "picom";
    package = inputs.picom.packages.${settings.system.platform}.default;
    # package = pkgs.picom;
    extraFlags = "--config ${dotfiles.path}/picom.conf";
  };
in
{
  environment.systemPackages = [ picom ];
}
