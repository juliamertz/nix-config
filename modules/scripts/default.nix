{ pkgs, ... }:
let
  call = pkgs.callPackage;
in
{
  wake = call ./wake.nix { };
}
