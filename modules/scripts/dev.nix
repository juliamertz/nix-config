{ writeShellScriptBin, ... }:
writeShellScriptBin "dev" ''
  if [ -f shell.nix ]; then
    nix-shell ./shell.nix --run $SHELL
  elif [ -f flake.nix ]; then
    nix develop ./ -c $SHELL 
  fi
''
