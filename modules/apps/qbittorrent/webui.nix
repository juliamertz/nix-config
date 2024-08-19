{ stdenv, fetchgit, fetchzip }: {
  # An iOS styled, mobile focused WebUI theme
  iQbit = stdenv.mkDerivation {
    name = "iQbit";
    installPhase = "cp -rv $src/release $out";
    src = fetchgit {
      url = "https://github.com/ntoporcov/iQbit.git";
      hash = "sha256-UBFNJIRx/u8xJrK/rJ0//32DzG6nwSqMt3YillyDWno";
    };
  };
  # A custom WebUI written in Typescript and VueJS with extra features, such as RSS and dark mode.
  qb-web = stdenv.mkDerivation {
    name = "qb-web";
    installPhase = "cp -rv $src $out";
    src = fetchzip {
      url = "https://github.com/CzBiX/qb-web/releases/download/nightly-20230513/qb-web-nightly-20230513.zip";
      hash = "sha256-fcH1K0aaCRQivcza3RKuoTo5Mjqi3Kgmt++CHkrneH0=";
    };
  };
  qbit-matui = stdenv.mkDerivation {
    name = "qbit-matui";
    installPhase = "cp -rv $src $out";
    src = fetchzip {
      url = "https://github.com/bill-ahmed/qbit-matUI/releases/download/v1.16.4/qbit-matUI_Unix_1.16.4.zip";
      hash = "";
    };
  };
  darklight = stdenv.mkDerivation {
    name = "darklight-qbittorrent";
    installPhase = "cp -rv $src/www $out";
    src = fetchzip {
      url = "https://github.com/crash0verride11/DarkLight-qBittorent-WebUI/releases/download/v0.5/www.zip";
      hash = "sha256-CSJ+Ci0xhLY0P4pKhRz4M65m4Vbf04LMbkJEgGVFL/w=";
      stripRoot = false;
    };
  };
}
