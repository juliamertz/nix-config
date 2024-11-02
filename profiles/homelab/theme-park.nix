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
    rev = "ec7ddaba02a24654e9c571d5d2ad1dcfc12230df";
    sha256 = "sha256-eF7RTgTK0aRkXChqs7wsIuy7UkI3O5FbuzwxQrc8IqY=";
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
