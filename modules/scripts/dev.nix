{ writeShellScriptBin, ... }:
writeShellScriptBin "dev" ''
  find_first() {
    find ./ -maxdepth 2 -type f -iname $1 | tail -n 1
  }

  shell=''${1:-"default"}

  file=$(find_first shell.nix)
  if [[ -f "$file" ]]; then
    nix-shell $file#$shell --run $SHELL
    exit
  fi

  file=$(find_first flake.nix)
  if [[ -f "$file" ]]; then
    nix develop $(dirname $file)#$shell -c $SHELL 
  fi
''
