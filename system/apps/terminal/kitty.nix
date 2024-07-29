{ pkgs, dotfiles, helpers, ... }:
let
  kitty = helpers.wrapPackage {
    name = "kitty";
    package = pkgs.kitty;
    extraFlags = "--config ${dotfiles.path}/kitty/kitty.conf";
  };
in { environment.systemPackages = [ kitty ]; }
