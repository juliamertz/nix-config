let
  pkgs = import <nixpkgs> {};

  inherit (pkgs) system;

  flake = builtins.getFlake "path:/home/julia/nix-config";
  image = flake.packages.${system}.docker-image;

  extraPackages = with pkgs; [
    minio-client
  ];
in
  image.override { inherit extraPackages; }
