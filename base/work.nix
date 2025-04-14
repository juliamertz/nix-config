{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    bazelisk # bazel version manager

    # kubernetes/containers
    kubectl
    k9s
    k3d
    docker
  ];

  homebrew.casks = [
    "slack"
    "linear-linear"
    "orbstack" # docker/kubernetes gui
  ];
}
