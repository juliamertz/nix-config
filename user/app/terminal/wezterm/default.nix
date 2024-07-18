{ pkgs, config, ... }:
{
  home.packages = [ pkgs.wezterm ];

  home.file."${config.xdg.configHome}/wezterm" = {
    source = "${config.dotfiles.path}/wezterm";
    recursive = true;
  };
}
