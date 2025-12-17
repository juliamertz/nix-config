{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.services.theme-park;

  themepark = let
    repo = "juliamertz/theme.park";
    rev = "0f99c377e6a41dd90c12e007eacbae18a36c5286";
  in
    (builtins.getFlake "github:${repo}/${rev}?dir=nix").packages.${pkgs.stdenv.hostPlatform.system}.default;
in {
  options.services.theme-park = with lib; {
    enable = mkEnableOption (mkDoc "theme.park");
    openFirewall = mkEnableOption (mkDoc "Open firewall port to static file server");
    port = mkOption {
      type = types.port;
      default = 5069;
    };
  };

  config = {
    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [cfg.port];
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
