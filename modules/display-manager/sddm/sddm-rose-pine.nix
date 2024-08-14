{ qtbase, qtsvg, qtgraphicaleffects, qtquickcontrols2, wrapQtAppsHook
, stdenvNoCC, fetchFromGitHub }:
stdenvNoCC.mkDerivation {
  pname = "sddm-rose-pine";
  version = "1..0";
  dontBuild = true;
  src = fetchFromGitHub {
    owner = "juliamertz";
    repo = "sddm-rose-pine";
    rev = "5665b3630d4b3ca546cf74e6f0f511d5462f52a7";
    sha256 = "sha256-QVnydE1NL0S/+4N7dkgjEB3I7DWWs5FHOhY3ovxnaYA=";
  };

  nativeBuildInputs = [ wrapQtAppsHook ];
  propagatedUserEnvPkgs = [ qtbase qtsvg qtgraphicaleffects qtquickcontrols2 ];

  installPhase = ''
    mkdir -p $out/share/sddm/themes
    cp -aR $src $out/share/sddm/themes/rose-pine
  '';
}
