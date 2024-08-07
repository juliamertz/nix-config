{ pkgs, helpers, dotfiles, ... }:
let
  zsh = helpers.wrapPackage {
    name = "zsh";
    package = pkgs.zsh;
    extraArgs = "--set ZDOTDIR '${dotfiles.path}/zsh'";
    dependencies = with pkgs; [ bat jq zoxide ];
  };
in { environment.systemPackages = [ zsh ]; }
