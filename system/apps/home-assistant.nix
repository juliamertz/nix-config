{ settings, inputs, ... }:
let
  platform = settings.system.platform;
  pkg = inputs.nixpkgs-24_05.legacyPackages.${platform}.sunshine;
in {
  environment.systemPackages = [ pkg ];
  services.home-assistant = {
    enable = true;    
    configDir = /home/${settings.user.username}/home-assistant;
    config = { };
  }; 
}
