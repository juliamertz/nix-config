{...}: {
  nix = {
    linux-builder = {
      enable = true;
      config.virtualisation.cores = 4;
    };
    settings = {
      trusted-users = ["@admin"];
      builders-use-substitutes = true;
      builders = let
        ARCH = "aarch64";
        MAX_JOBS = 4;
        PUB_KEY = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUpCV2N4Yi9CbGFxdDFhdU90RStGOFFVV3JVb3RpQzVxQkorVXVFV2RWQ2Igcm9vdEBuaXhvcwo=";
      in "ssh-ng://builder@linux-builder ${ARCH}-linux /etc/nix/builder_ed25519 ${toString MAX_JOBS} - - - ${PUB_KEY}";
    };
  };
}
