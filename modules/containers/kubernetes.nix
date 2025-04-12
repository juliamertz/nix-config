{pkgs, ...}: {
  imports = [
    ./runtime/docker.nix
  ];

  environment.systemPackages = with pkgs; [
    kubectl
    kind
    k9s
  ];
}
