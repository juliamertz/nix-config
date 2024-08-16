{ inputs, helpers, ... }:
let
  branch = inputs.nixpkgs-unstable;
  settings = {
    "identity.fxaccounts.enabled" = false; # Set up local sync server first
    "privacy.resistFingerprinting" = true;
    "privacy.clearOnShutdown.history" = false;
    "privacy.clearOnShutdown.downloads" = false;
    "browser.sessionstore.resume_from_crash" = true;
    "middlemouse.paste" = false;
    "general.autoScroll" = false;
  };
in {
  home.config = {
    programs.librewolf = {
      enable = true;
      package = (helpers.getPkgs branch).librewolf;
      inherit settings;
    };

    xdg.mimeApps.defaultApplications = {
      "text/html" = "librewolf.desktop";
      "x-scheme-handler/http" = "librewolf.desktop";
      "x-scheme-handler/https" = "librewolf.desktop";
      "x-scheme-handler/about" = "librewolf.desktop";
      "x-scheme-handler/unknown" = "librewolf.desktop";
    };
  };
}
