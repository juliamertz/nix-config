{ settings, inputs, ... }:
let
  platform = settings.system.platform;
  pkg = inputs.nixpkgs-24_05.legacyPackages.${platform}.sunshine;
in {
  environment.systemPackages = [ pkg ];
  services.home-assistant = {
    enable = true;
    configDir = /home/${settings.user.username}/home-assistant;
    extraComponents = [
      # Components required to complete the onboarding
      "esphome"
      "met"
      "radio_browser"
    ];
    config = {
      # Includes dependencies for a basic setup
      # https://www.home-assistant.io/integrations/default_config/
      default_config = {};
    };
  };
}
