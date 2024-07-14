{ pkgs, lib, settings, ... }:
{
  environment.systemPackages = with pkgs; [ home-assistant ];
  services.home-assistant = {
    enable = true;    
    configDir = /home/${settings.user.username}/home-assistant;
    config = { };
  }; 
}
