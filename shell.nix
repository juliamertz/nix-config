{
  pkgs ? import <nixpkgs> { },
}:
with pkgs;
let
  inherit (lib) getExe;
  clean =
    writeShellScriptBin "clean" # sh
      ''
        ${getExe deadnix} --edit
        ${getExe statix} fix
      '';
  check =
    writeShellScriptBin "check" # sh
      ''
        ${getExe deadnix}
        ${getExe statix} check
      '';
in

mkShell {
  packages = [
    clean
    check

    nixfmt-rfc-style
    deadnix
    statix
  ];
}
