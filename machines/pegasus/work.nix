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
    aptakube
  ];

  homebrew.casks = [
    "slack"
    "linear-linear"
    "orbstack"
  ];
}
