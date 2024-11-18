{ pkgs }:
let
  inherit (pkgs) lib;
in
lib.mapAttrs (_: path: pkgs.callPackage path { }) {
  wake = ./wake.nix;
  deref = ./deref.nix;
  steamgame = ./steamgame.nix;
}
