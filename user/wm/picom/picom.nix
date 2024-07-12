{ pkgs, config, ... }:
{
  home.packages = with pkgs; [ picom ];
  
  services.picom.enable = true;

  home.file."${config.xdg.configHome}/picom.conf".source = ./picom.conf;
}
