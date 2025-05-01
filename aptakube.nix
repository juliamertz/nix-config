let
  pkgs = import <nixpkgs> {};

  inherit (pkgs) stdenv fetchurl;
in
  stdenv.mkDerivation rec {
    pname = "aptakube";
    version = "1.11.4";
    src = fetchurl {
      url = "https://releases.aptakube.com/Aptakube_${version}_universal.dmg";
      sha256 = "sha256-XhKktFcHto9WwHM4tNZy1UtoNHZLjjrStTrmW3ybLgo=";
    };

    nativeBuildInputs = with pkgs; [
      undmg
    ];

    unpackPhase = ''
      undmg $src
    '';

    installPhase = ''
      mkdir -p $out
      cp -vr Aptakube.app $out/Aptakube.app
    '';
  }
