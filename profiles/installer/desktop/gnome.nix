{ lib, config, ... }:
{
  imports = [
    ../base/installer-desktop.nix
    ../base/graphical.nix
  ];

  isoImage.edition = lib.mkDefault "gnome";

  installer-desktop.enable = true;

  services.xserver.desktopManager.gnome = {
    enable = true;
    favoriteAppsOverride = ''
      [org.gnome.shell]
      favorite-apps=[ ${
        map (file: "'${builtins.baseNameOf file}'") config.installer-desktop.paths
        |> lib.concatStringsSep ", "
      } ]
    '';
  };

  services.xserver.displayManager.gdm = {
    enable = true;
    autoSuspend = false;
  };

  services.displayManager.autoLogin = {
    enable = true;
    user = "nixos";
  };
}
