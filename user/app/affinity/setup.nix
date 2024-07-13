{ pkgs, lib, config, ... }:
let 
  cfg = config.affinity;
  script = /* bash */ ''
    #!/usr/bin/env bash
    # https://codeberg.org/Wanesty/affinity-wine-docs
    set -eu

    winepath="${pkgs.wineElementalWarrior}"

    export WINEPREFIX="${cfg.prefix}"
    export PATH="$winepath/bin:$PATH"
    export LD_LIBRARY_PATH="$winepath/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
    export WINEDLLOVERRIDES="winemenubuilder.exe=d"
    export WINESERVER="$winepath/bin/wineserver"
    export WINELOADER="$winepath/bin/wine"
    export WINEDLLPATH="$winepath/lib/wine"
        
    # this crime is required to make wineboot not try to install mono itself
    WINEDLLOVERRIDES="mscoree=" wineboot --init
    $winepath/bin/wine msiexec /i "$winepath/share/wine/mono/wine-mono-8.1.0-x86.msi"
    ${pkgs.winetricks}/bin/winetricks -q dotnet48 corefonts vcrun2015
    $winepath/bin/wine winecfg -v win11
  '';

  binary = (pkgs.writeShellScriptBin "setup" script);
in {
  home.activation.setup-affinity-wine = lib.hm.dag.entryAfter [ "writeBoundary" ] ''${binary}/bin/setup'';
}
