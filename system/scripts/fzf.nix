{ pkgs, ... }:
let
  fd = /*bash*/ ''
    find ''${@:-.} -type d | fzf
  '';
  ff = /*bash*/ ''
    find ''${@:-.} -type f | fzf
  '';
in {
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "fd" fd)
    (pkgs.writeShellScriptBin "ff" ff)
  ];
}
