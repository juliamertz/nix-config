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
  themepark = pkgs.fetchFromGitHub {
    owner = "juliamertz";
    repo = "theme.park";
    rev = "c60a471f1de5f5cd2da45e10fb95a24101aa93cc";
    hash = "sha256-W7012/v3FSzwR9+ODOMHJUdLog3H/h+c7BPn+mODBJ0=";
  };
  copiedFile = path: {
    source = path;
    # mode = "0600";
    user = settings.user.username;
    group = builtins.toString config.services.theme-park.gid;
  };
in
{
  # imports = [ ../../modules/containers/theme-park.nix ];

  options.services.theme-park = with lib; {
    enable = mkEnableOption "theme.park";
    openFirewall = mkEnableOption "Open firewall port to static file server";
    port = mkOption {
      type = types.number;
      default = 5069;
    };
  };

  config = {
    systemd.services.theme-park = {
      description = "theme.park static file server";

      serviceConfig = {
        Type = "simple";
        ExecStart = "${lib.getExe pkgs.simple-http-server} --port 5069 -i ${themepark}";
      };
    };

    # environment.etc = lib.mkMerge (
    #   map (t: { "theme-park/www/css/theme-options/${t}.css" = copiedFile "${rosepine}/themes/${t}.css"; })
    #     [
    #       "rose-pine-moon"
    #       "rose-pine-dawn"
    #       "rose-pine"
    #     ]
    # );
  };
}
