{ pkgs, dotfiles, helpers, ... }:
let
  lazygit = helpers.wrapPackage {
    name = "lazygit";
    package = pkgs.lazygit;
    extraFlags = "--use-config-file ${dotfiles.path}/lazygit/config.yml";
    dependencies = with pkgs; [ delta ];
  };
in
{
  environment.systemPackages = [ lazygit ];
}
