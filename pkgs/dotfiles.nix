{ stdenvNoCC, lib, ... }:
{ rev, localPath, useLocalPath }:
let 
  installPhase = if useLocalPath then ''
    cp -aR $src $out
  '' else ''
    ln -s $src $out/.local
  '';
in stdenvNoCC.mkDerivation {
  # inherit installPhase;
  pname = "dotfiles";
  version = "0.0.1";
  dontBuild = true;
  src = builtins.fetchGit {
    url = "https://github.com/juliamertz/dotfiles";
    rev = "75b211bec64532922feec4d080de9310fb877ab5";
  };

  installPhase = ''
    cp -aR $src $out
  '' + lib.mkIf useLocalPath ''
    ln -s $src $out/.local
  '' ;
}
