{
  pkgs,
  config,
  ...
}: let
  custom-components = pkgs.home-assistant-custom-components;
  custom-lovelace-modules = pkgs.home-assistant-custom-lovelace-modules;
  custom-themes = pkgs.home-assistant-custom-themes;

  lights = [
    "bed"
    "bed_links"
    "bureau"
    "bureau_links"
    "kast"
  ];

  include = path: pkgs.callPackage path {inherit lights;};
in {
  services.home-assistant = {
    enable = true;
    openFirewall = true;

    extraComponents = [
      "default_config"
      "isal" # faster alternative to zlib compression
      "open_meteo" # weather provider
      "hue"
    ];

    customComponents = with custom-components; [
      localtuya
      auth_oidc
    ];

    config = {
      weather = {};

      light = [
        {
          platform = "group";
          name = "All";
          unique_id = "all";
          entities = map (name: "light.${name}") lights;
        }
      ];

      http = {
        use_x_forwarded_for = true;
        trusted_proxies = [
          "100.64.0.0/24"
          "192.168.0.100"
          "10.100.0.1"
          "127.0.0.1"
        ];
      };

      auth_oidc = {
        client_id = "home-assistant";
        # TODO: provision this secret with sops to /var/lib/hass/secrets.yaml
        client_secret = "!secret oidc_client_secret";
        discovery_url = "https://auth.juliamertz.dev/.well-known/openid-configuration";
        display_name = "Authelia";
        roles = {admin = "home-assistant-admins";};
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

  reverse-proxy.services.home-assistant = {
    subdomain = "hass";
    port = config.services.home-assistant.port;
  };

  imports = [
    ./automations.nix

    ../../../../modules/apps/home-assistant
  ];
}
