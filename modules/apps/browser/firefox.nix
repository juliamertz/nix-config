{ pkgs, helpers, ... }:
(
  if helpers.isDarwin then
    { homebrew.casks = [ "firefox" ]; }
  else
    {
      environment.systemPackages = with pkgs; [ firefox ];

      xdg.mimeApps.defaultApplications =
        let
          name = "firefox";
        in
        {
          "text/html" = "${name}.desktop";
          "x-scheme-handler/http" = "${name}.desktop";
          "x-scheme-handler/https" = "${name}.desktop";
          "x-scheme-handler/about" = "${name}.desktop";
          "x-scheme-handler/unknown" = "${name}.desktop";
        };
    }
)
