{ pkgs, rev, local, repo }: 
let 
  pkg = pkgs.stdenvNoCC.mkDerivation {
    installPhase = ''
      cp -aR $src $out
    '';
    pname = "dotfiles";
    version = "0.0.1";
    dontBuild = true;
    src = builtins.fetchGit {
      url = repo;
      rev = rev;
    };
  };
in {
  path = if local.enable then local.path else builtins.toString pkg;
}
