{ pkgs, ... }:
{
  home.packages = with pkgs; [
    wofi
  ];

  home.file.".config/wofi/style.css" = {
    source = ./style.css;
  };
}
