# Affinity wine nix configuration
> This module only sets up wine and creates binaries for applications in the affinity suite, The wine prefix containing all applications should be provided by the user

```bash
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
wine msiexec /i "$winepath/share/wine/mono/wine-mono-8.1.0-x86.msi"
winetricks -q dotnet48 corefonts vcrun2015
wine winecfg -v win11
# grab from a real windows computer
```
