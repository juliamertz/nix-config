
{ pkgs, helpers, dotfiles, ... }:
let
  # dotfiles = dotfiles.path;
  zsh = helpers.wrapPackage {
    name = "zsh";
    package = pkgs.zsh;
    extraArgs =   "--set XDG_CONFIG_HOME '${dotfiles.path}'" + " --set ZDOTDIR '${dotfiles.path}/zsh'";
    dependencies = with pkgs; [ bat jq zoxide ];
  };
in
{
  environment.systemPackages = [ zsh ];
}
