{
  stdenvNoCC,
  fetchurl,
  perl,
  ...
}:
stdenvNoCC.mkDerivation rec {
  name = "fishies";
  buildInputs = [
    (perl.withPackages (
      perlPackages: with perlPackages; [
        Curses
        TermAnimation
      ]
    ))
  ];

  unpackPhase = "src=${
    fetchurl {
      url = "https://raw.githubusercontent.com/rwxrob/dot/416d145171ccdda137b201e033e1ff3781e6dc3b/scripts/fishies";
      hash = "sha256-LABkYGb0yt1sKcKpZ7KW/BqDEyScRBNLAwzC7UZNgFI=";
    }
  }";

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/fishies
    chmod +x $out/bin/fishies
  '';

  meta.mainProgram = name;
}
