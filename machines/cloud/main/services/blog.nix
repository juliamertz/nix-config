{
  pkgs,
  config,
  ...
}: let
  inherit (config.services.caddy) domain;

  blog = with pkgs;
    stdenvNoCC.mkDerivation {
      name = "blog";
      nativeBuildInputs = [zola];
      src = fetchFromGitHub {
        owner = "juliamertz";
        repo = "blog";
        rev = "19538f6ab56bc02691bc1cf99452e250f945d97f";
        hash = "sha256-plh6147G8i9rCvYEuMBOxQBl9f1mddwVuY0D4sN/aGc=";
      };

      buildPhase = "zola build -o $out";
    };
in {
  services.caddy.virtualHosts.${domain}.extraConfig = "redir https://github.com/juliamertz";
  # ''
  #   encode gzip
  #   file_server
  #   root * ${blog}
  # '';
}
