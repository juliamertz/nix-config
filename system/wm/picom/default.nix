{ dotfiles, pkgs, helpers, ... }:
let
  picom = helpers.wrapPackage {
      name = "picom";
      package = pkgs.picom;
      extraFlags = "--config ${dotfiles.path}/picom.conf";
  };
in
{
  environment.systemPackages = [ picom ];
}
