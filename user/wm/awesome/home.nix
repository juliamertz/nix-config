{ pkgs, config, ... }:
{
  imports = [
    ../widgets/rofi/rofi.nix
  ];

  xsession.windowManager.awesome.enable = true;

  home.file."${config.xdg.configHome}/awesome" = {
    source = ./config;
    recursive = true;
  };
}
