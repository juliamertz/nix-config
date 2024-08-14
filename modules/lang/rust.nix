{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    pkg-config
    gcc
    gnumake
    rustc
    cargo
    rustfmt
    rust-analyzer
    clippy
  ];
}
