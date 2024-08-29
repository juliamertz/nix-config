{ pkgs, helpers, ... }: {
  environment.systemPackages = with pkgs;
    [ go gopls ] ++ lib.optionals helpers.isLinux [ libcap gcc ];
}
