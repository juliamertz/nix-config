{ pkgs, ... }:
let
  deref = # bash
    ''
      #!${pkgs.bash}

      if [ -h "$1" ] ; then
        target=`readlink $1`
        rm "$1"
        cp "$target" "$1"
      fi
    '';
in
{
  environment.systemPackages = [ (pkgs.writeShellScriptBin "deref" deref) ];
}
