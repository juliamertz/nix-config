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
        ${getExe nixfmt-rfc-style} .
      '';
  check =
    writeShellScriptBin "check" # sh
      ''
        ${getExe deadnix}
        ${getExe statix} check
        ${getExe nixfmt-rfc-style} --check .
      '';
in

mkShell {
  packages = [
    clean
    check

    nixos-generators
    nixfmt-rfc-style
    deadnix
    statix
  ];
}
