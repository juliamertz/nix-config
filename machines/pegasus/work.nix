{
  inputs,
  pkgs,
  ...
}: let
  pkgs-24_11 = import inputs.nixpkgs-24_11 {inherit (pkgs) system;};
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
      version = "1.13.1";
    in {
      src = fetchurl {
        url = "https://github.com/aptakube/aptakube/releases/download/${version}/Aptakube_${version}_universal.dmg";
        sha256 = "sha256-Koa1wAH0jv7530umi51JWo7F+LCYdl/B5zFGph+1orY=";
      };
    }))
  ];

  homebrew.casks = [
    "slack"
    "linear-linear"
    "orbstack"
  ];
}
