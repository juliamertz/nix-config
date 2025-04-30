{pkgs, ...}: {
  nix = {
    linux-builder = {
      enable = true;
      config.virtualisation.cores = 4;
    };
    settings.trusted-users = ["@admin"];
  };
}
