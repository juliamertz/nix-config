{ pkgs, ... }:
let
  cfg = "";
in {
  home.packages = with pkgs; [
    jellyfin
    jellyfin-web
  ];
}
