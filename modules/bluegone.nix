{ lib, rustPlatform, fetchFromGitHub, pkg-config, openssl, cmake }:

rustPlatform.buildRustPackage rec {
  pname = "bluegone";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "juliamertz";
    repo = pname;
    rev = "dc696338151372d18af685210a4c45b11e4eb87c";
    hash = "sha256-2deePRX43CUTvUzjOZYqfM7p6g43gQtZtWZFzbH1+zQ=";
  };

  cargoHash = "sha256-LIliO3gd6MeqbNpBv40f9rvskUiUAPSeAGLcqD1mx98=";

  buildInputs = [ openssl ];
  nativeBuildInputs = [ pkg-config cmake rustPlatform.bindgenHook ];

  buildNoDefaultFeatures = true;

  meta = {
    description = "A blue light filter for x11 desktops";
    homepage = "https://github.com/juliamertz/bluegone";
    mainProgram = "bluegone";
  };
}
