{
  inputs,
  pkgs,
  ...
}: let
  pkgs-24_11 = import inputs.nixpkgs-24_11 {inherit (pkgs.stdenv.hostPlatform) system;};
in {
  environment.systemPackages = with pkgs; [
    k9s
    docker
    k3d
    kubie
    kubectl
    kubectl-cnpg
    pkgs-24_11.kubelogin
    (aptakube.overrideAttrs (let
      version = "1.18.6";
    in {
      src = fetchurl {
        url = "https://github.com/aptakube/aptakube/releases/download/${version}/Aptakube_${version}_universal.dmg";
        sha256 = "sha256-goO3m792448YziwfryOFncPv9pVTL6/l5EqR8LAzX/4=";
      };
    }))
  ];

  homebrew.casks = [
    "slack"
    "linear-linear"
    "orbstack"
  ];
}
