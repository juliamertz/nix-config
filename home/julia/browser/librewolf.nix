{
  inputs,
  pkgs,
  lib,
  helpers,
  ...
}: let
  firefoxAddons = inputs.nur.packages.${pkgs.system}.firefoxAddons;
  profile = import ./profile.nix {inherit pkgs firefoxAddons;};
in
  {
    programs.librewolf = {
      enable = true;
      profiles.julia = profile;
    };

    xdg.mimeApps.defaultApplications = {
      "text/html" = "librewolf.desktop";
      "x-scheme-handler/http" = "librewolf.desktop";
      "x-scheme-handler/https" = "librewolf.desktop";
      "x-scheme-handler/about" = "librewolf.desktop";
      "x-scheme-handler/unknown" = "librewolf.desktop";
    };
  }
  // (lib.optionalAttrs helpers.isLinux {
    stylix.targets.librewolf.profileNames = [
      "julia"
    ];
  })
