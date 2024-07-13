# Required options
# prefix: path to affinity wine prefix containing all affinity software
{ pkgs, config, lib, settings, ... }:
let
  cfg = config.affinity;
  bin = pkgs.writeShellScriptBin;

  prefix = ''WINE_PREFIX=${cfg.prefix}'';
  executables = ''${cfg.prefix}/drive_c/Program\ Files/Affinity'';
  wine = "${pkgs.affinity}/bin/affinity wine";
  
  exec = {
    designer = ''${prefix} ${wine} ${executables}/Designer\ 2/Designer.exe'';
    photos = ''${prefix} ${wine} ${executables}/Photo\ 2/Photo.exe'';
  };
  pkg = {
    designer = bin "affinity-designer" exec.designer;
    photos = bin "affinity-photos" exec.photos;
  };
in {
  imports = [
    ./wine.nix
    ./launcher.nix # Provides pkgs.affinity
    ./setup.nix
  ];

  options.affinity = {
    prefix = lib.mkOption { type = lib.types.str; default = ""; };
  };

  config = {
    home.packages = [ 
      pkg.designer 
      pkg.photos 
    ];

    xdg.desktopEntries = { 
      designer = {
         name = "Affinity Designer";
         genericName = "Vector Graphics editor";
         exec = exec.designer;
         terminal = false;
         categories = [ "Utility" ];
      };
      Photos = {
         name = "Affinity Photos";
         genericName = "Image Editor";
         exec = exec.photos;
         terminal = false;
         categories = [ "Utility" ];
      };
    };
  };
}

