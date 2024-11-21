{
  pkgs,
  lib,
  config,
  settings,
  ...
}:
let
  rosepine = pkgs.fetchFromGitHub {
    owner = "juliamertz";
    repo = "rose-pine-themepark";
    rev = "80447c492990568629b4fb37a8204df632cb368d";
    hash = "sha256-9QA/r+ZtFwnDqhj+tWDiDqogaMt4VYXud0iJhf+Tq7g=";
  };
  copiedFile = path: {
    source = path;
    mode = "0600";
    user = settings.user.username;
    group = builtins.toString config.services.theme-park.gid;
  };
in
{
  imports = [ ../../modules/containers/theme-park.nix ];

  services.theme-park = {
    enable = true;
    openFirewall = true;
    tag = "latest";
    port = 5069;
    urlBase = "themepark";
    configPath = "/etc/theme-park";
  };

  environment.etc = lib.mkMerge (
    map (t: { "theme-park/www/css/theme-options/${t}.css" = copiedFile "${rosepine}/themes/${t}.css"; })
      [
        "rose-pine-moon"
        "rose-pine-dawn"
        "rose-pine"
      ]
  );
}
