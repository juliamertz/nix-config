{ lib, pkgs, ... }:
{
  services.xserver = {
    enable = true;
  };

  services.xserver.windowManager.awesome = {
    enable = true;
    luaModules = with pkgs.luaPackages; [ luarocks ];
  };

  services.displayManager = {
    sddm.enable = true;
    defaultSession = "none+awesome";
  };
}
