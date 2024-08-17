{ stdenv, fetchgit }: {
  iQbit = stdenv.mkDerivation {
    name = "iQbit";
    installPhase = "cp -rv $src/release $out";
    src = fetchgit {
      url = "https://github.com/ntoporcov/iQbit.git";
      hash = "sha256-UBFNJIRx/u8xJrK/rJ0//32DzG6nwSqMt3YillyDWno";
    };
  };
}
