{ pkgs, helpers, ... }: {
  environment.systemPackages = with pkgs;
    [ pkg-config gcc gnumake rustc cargo rustfmt rust-analyzer ]
    ++ lib.optionals helpers.isLinux [ clippy ];
}
