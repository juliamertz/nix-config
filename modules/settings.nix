{
  config,
  lib,
  helpers,
  ...
}: let
  cfg = config.settings;
in {
  options.settings = with lib; {
    timeZone = mkOption {
      type = types.str;
      default = "Europe/Amsterdam";
    };

    locale = mkOption {
      type = types.str;
      default = "en_US.UTF-8";
    };
    extraLocale = mkOption {
      type = types.str;
      default = "nl_NL.UTF-8";
    };
  };

  config = helpers.perPlatform {
    linux = {
      time.timeZone = cfg.timeZone;
      i18n = {
        defaultLocale = cfg.locale;
        extraLocaleSettings = {
          LC_ADDRESS = cfg.extraLocale;
          LC_IDENTIFICATION = cfg.extraLocale;
          LC_MEASUREMENT = cfg.extraLocale;
          LC_MONETARY = cfg.extraLocale;
          LC_NAME = cfg.extraLocale;
          LC_NUMERIC = cfg.extraLocale;
          LC_PAPER = cfg.extraLocale;
          LC_TELEPHONE = cfg.extraLocale;
          LC_TIME = cfg.extraLocale;
        };
      };
    };

    darwin = {};
  };
}
