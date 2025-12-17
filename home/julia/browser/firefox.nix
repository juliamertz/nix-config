{
  inputs,
  pkgs,
  ...
}: let
  pkgs-25_05 = import inputs.nixpkgs-25_05 {inherit (pkgs.stdenv.hostPlatform) system;};
  firefoxAddons = inputs.nur.packages.${pkgs.stdenv.hostPlatform.system}.firefoxAddons;
  profile = import ./profile.nix {inherit pkgs firefoxAddons;};
in {
  programs.firefox = {
    enable = true;
    package = pkgs-25_05.firefox;
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
