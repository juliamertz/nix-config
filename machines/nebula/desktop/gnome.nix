{
  lib,
  config,
  ...
}: {
  imports = [
    ../base/installer-desktop.nix
    ../base/graphical.nix
  ];

  isoImage.edition = lib.mkDefault "gnome";

  installer-desktop.enable = true;

  services.xserver.desktopManager.gnome = let
    favoriteApps =
      map (
        pkg: let
          desktopFiles = builtins.readDir "${pkg}/share/applications/" |> lib.attrNames;
        in
          map (filename: "'${filename}'") desktopFiles |> lib.concatStringsSep ", "
      )
      config.installer-desktop.paths
      |> lib.concatStringsSep ", ";
  in {
    enable = true;
    favoriteAppsOverride = ''
      [org.gnome.shell]
      favorite-apps=[ ${favoriteApps} ] '';
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
