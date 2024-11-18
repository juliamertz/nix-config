{ writeShellScriptBin }:
writeShellScriptBin "," ''
  nix-shell -p "$@" --run $SHELL
''
