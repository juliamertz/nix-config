{
  lib,
  config,
  ...
}: let
  cfg = config.installer-desktop;
  defaultPaths = ["/run/current-system/sw"];
in {
  options.installer-desktop = with lib; {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    paths = mkOption {
      type = types.listOf (types.either types.str types.path);
      default = [];
    };
  };

  config = lib.mkIf cfg.enable {
    system.activationScripts.installerDesktop = let
      user = "nixos";
      homeDir = "/home/${user}/";
      desktopDir = homeDir + "Desktop/";

      linkDesktopFiles =
        map (path: "ln -sfT ${path}/share/applications/*.desktop ${desktopDir}") (cfg.paths ++ defaultPaths)
        |> lib.concatStringsSep "\n";
    in
      ''
        mkdir -p ${desktopDir}
        chown nixos ${homeDir} ${desktopDir}
      ''
      + linkDesktopFiles;
  };
}
