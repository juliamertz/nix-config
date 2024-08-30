{ pkgs, dotfiles, helpers, ... }:
let
  kitty = helpers.wrapPackage {
    name = "kitty";
    package = pkgs.kitty;
    extraFlags = "--config ${dotfiles.path}/kitty/kitty.conf";
  };
in (if helpers.isDarwin then {
  homebrew.casks = [ "kitty" ];
  home.file.".config/kitty" = {
    source = "${dotfiles.path}/kitty";
    recursive = true;
  };
} else {
  environment.systemPackages = [ kitty ];
})
