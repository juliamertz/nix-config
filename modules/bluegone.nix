{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  cmake,
}:

rustPlatform.buildRustPackage rec {
  pname = "bluegone";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "juliamertz";
    repo = pname;
    rev = "2b4cf8c497b1d8bd31ef7e7bbb42a44af8eb7a2d";
    hash = "sha256-TMLqWtau6fSNBEkjZbDT/m10Bo8mTeBFgnE09F7Qou0=";
  };

  cargoHash = "sha256-B0zNm9SRVfwtLNww7wcFkiBNJUfLoaiCzIJyRUmRsKQ=";

  buildInputs = [ openssl ];
  nativeBuildInputs = [
    pkg-config
    cmake
    rustPlatform.bindgenHook
  ];

  buildNoDefaultFeatures = true;

  meta = {
    description = "A blue light filter for x11 desktops";
    homepage = "https://github.com/juliamertz/bluegone";
    mainProgram = "bluegone";
  };
}
