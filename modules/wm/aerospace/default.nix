{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.wm.aerospace;
in {
  options = {
    wm.aerospace = with lib; {
      enable = mkEnableOption "Aerospace window manager";

      autoStart = mkEnableOption "Automatically start Aerospace at launch";

      package = mkOption {
        type = types.package;
        default = pkgs.aerospace;
      };

      configPath = mkOption {
        type = types.path;
        default = "/etc/aerospace/config.toml";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [cfg.package];

    launchd.user.agents.aerospace = lib.mkIf cfg.autoStart {
      command = ''
        ${cfg.package}/Applications/AeroSpace.app/Contents/MacOS/AeroSpace \
            --config-path ${cfg.configPath}
      '';

      serviceConfig = {
        KeepAlive = true;
        RunAtLoad = true;
      };
    };

    system.defaults = {
      dock.expose-group-apps = true;
      spaces.spans-displays = false;
    };
  };
}
