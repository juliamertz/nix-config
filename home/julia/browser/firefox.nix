{
  inputs,
  pkgs,
  lib,
  helpers,
  ...
}: let
  firefoxAddons = inputs.nur.packages.${pkgs.system}.firefoxAddons;
  profile = import ./profile.nix {inherit pkgs firefoxAddons;};
in {
  programs.firefox = {
    enable = true;
    profiles.julia = profile;
  };

  xdg.mimeApps.defaultApplications = {
    "text/html" = "firefox.desktop";
    "x-scheme-handler/http" = "firefox.desktop";
    "x-scheme-handler/https" = "firefox.desktop";
    "x-scheme-handler/about" = "firefox.desktop";
    "x-scheme-handler/unknown" = "firefox.desktop";
  };
}
