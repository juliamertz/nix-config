{
  pkgs,
  lib,
  config,
  settings,
  ...
}:
let
  cfg = config.services.theme-park;

  themepark =
    let
      repo = "juliamertz/theme.park";
      rev = "cdedb571787abc785e4bf4a24449f20a3d492370";
    in
    (builtins.getFlake "github:${repo}/${rev}?dir=nix").packages.${pkgs.system}.default;
in
{
  options.services.theme-park = with lib; {
    enable = mkEnableOption (mkDoc "theme.park");
    openFirewall = mkEnableOption (mkDoc "Open firewall port to static file server");
    port = mkOption {
      type = types.number;
      default = 5069;
    };
  };

  config = {
    networking.firewall = lib.mkIf cfg.openFirewall { allowedTCPPorts = [ cfg.port ]; };

    services.theme-park = {
      enable = true;
      port = 5069;
      openFirewall = true;
    };

    systemd.services.theme-park = lib.mkIf cfg.enable {
      description = "theme.park static file server";

      serviceConfig = {
        Type = "simple";
        ExecStart = ''
          ${lib.getExe pkgs.simple-http-server} \
              --port ${builtins.toString cfg.port} \
              -i ${themepark}/app/themepark
        '';
      };
    };
  };
}
