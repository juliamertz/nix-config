{ lib, pkgs, ... }:
{
  services.xserver = {
    enable = true;
  };

  # services.displayManager.defaultSession = "none+awesome";
  services.xserver.windowManager.awesome = {
    enable = true;
    luaModules = with pkgs.luaPackages; [ luarocks ];
  };
}
