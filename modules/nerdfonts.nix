{ pkgs, ... }:
let
  fonts = [ "JetBrainsMono" ];
  nerdfonts = pkgs.nerdfonts.override { inherit fonts; };
in
{
  fonts.packages = [ nerdfonts ];
}
