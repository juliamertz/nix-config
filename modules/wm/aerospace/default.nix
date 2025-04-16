{ dotfiles, ... }:
{
  services.aerospace = {
    enable = true;
    package = dotfiles.pkgs.aerospace;
    settings = { };
  };
}
