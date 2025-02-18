{
  pkgs,
  config,
  ...
}:
let
  custom-components = pkgs.home-assistant-custom-components;
  custom-lovelace-modules = pkgs.home-assistant-custom-lovelace-modules;
  custom-themes = pkgs.home-assistant-custom-themes;

  include = path: pkgs.callPackage path {};
in
{
  reverse-proxy.services.home-assistant = {
    subdomain = "hass";
    port = config.services.home-assistant.port;
  };

  services.home-assistant = {
    enable = true;
    openFirewall = true;

    extraComponents = [
      "default_config"
      "isal" # faster alternative to zlib compression
      "accuweather" # weather provider
      "hue"
    ];

    customComponents = with custom-components; [
      localtuya
    ];

    config = {
      default_config = { };
      weather = { };

      http = {
        use_x_forwarded_for = true;
        trusted_proxies = [
          "192.168.0.100"
          "127.0.0.1"
        ];
      };

      scene = include ./scenes.nix;
    };

    customThemes = with custom-themes; [
      rose-pine
    ];

    customLovelaceModules = with custom-lovelace-modules; [
      clock-weather-card
      mushroom
    ];

    lovelaceConfig = {
      title = "Home";
      views = include ./views.nix;
    };
  };

  imports = [
    ./automations.nix

    ../../../modules/apps/home-assistant
  ];
}
