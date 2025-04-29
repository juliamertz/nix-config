{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    k9s
    k3d
    docker
    kubie
    kubectl
    kubelogin
  ];

  homebrew.casks = [
    "slack"
    "linear-linear"
    "orbstack" # docker/kubernetes gui
  ];
}
