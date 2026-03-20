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
      version = "1.16.2";
    in {
      src = fetchurl {
        url = "https://github.com/aptakube/aptakube/releases/download/${version}/Aptakube_${version}_universal.dmg";
        sha256 = "sha256-l088CrlvHnXOmES7mCOr9WPUGH9+FGSnbUo6kUJVl44=";
      };
    }))
  ];

  homebrew.casks = [
    "slack"
    "linear-linear"
    "orbstack"
  ];
}
