{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    k9s
    k3d
    docker
    kubie
    kubectl
    kubectl-cnpg
    kubelogin
    aptakube
  ];

  homebrew.casks = [
    "slack"
    "linear-linear"
    "orbstack"
  ];
}
