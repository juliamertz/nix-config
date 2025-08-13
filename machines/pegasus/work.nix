{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    k9s
    k3d
    docker
    kubie
    kubectl
    kubectl-cnpg
    kubelogin
    (aptakube.overrideAttrs (let
      version = "1.12.4";
    in {
      src = fetchurl {
        url = "https://github.com/aptakube/aptakube/releases/download/${version}/Aptakube_${version}_universal.dmg";
        sha256 = "sha256-JGM8bapGBgQb1wa4HjJ1sa/iX8P95x/jw2wdibpqrw0=";
      };
    }))
  ];

  homebrew.casks = [
    "slack"
    "linear-linear"
    "orbstack"
  ];
}
