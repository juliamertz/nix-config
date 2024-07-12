{ pkgs, lib, config, ...}:
{
  # home.packages = with pkgs; [ rofi ];
  programs.rofi.enable = true;

  home.file."${config.xdg.configHome}/rofi" = {
    source = ./config;
    recursive = true;
  };
}
