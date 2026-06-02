{
  pkgs,
  lib,
  ...
}: {
  services.displayManager.lemurs = {
    enable = true;
    settings = {};
  };
}
