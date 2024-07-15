{ pkgs, config, lib, settings, ... }:
let
  cfg = config.affinity;
  bin = pkgs.writeShellScriptBin;

  prefix = ''WINE_PREFIX=${cfg.prefix}'';
  executables = ''${cfg.prefix}/drive_c/Program\ Files/Affinity'';
  wine = "${pkgs.affinity}/bin/affinity wine";
  
  exec = {
    photo = ''${prefix} ${wine} ${executables}/Photo\ 2/Photo.exe'';
    designer = ''${prefix} ${wine} ${executables}/Designer\ 2/Designer.exe'';
    publisher = ''${prefix} ${wine} ${executables}/Publisher\ 2/Publisher.exe'';
    run = ''${prefix} ${wine} $@'';
  };
  pkg = {
    photo = bin "affinity-photo" exec.photo;
    designer = bin "affinity-designer" exec.designer;
    publisher = bin "affinity-publisher" exec.publisher;
    run = bin "affinity-run" exec.run;
  };
in {
  imports = [
    ./wine.nix # ElementalWarrior wine build
    ./launcher.nix # Provides pkgs.affinity
    ./setup.nix # Installation step to create wine prefix
  ];

  options.affinity = {
    prefix = lib.mkOption { 
      type = lib.types.str;
      default = "";
    };
    setup_prefix = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
    designer.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
    photo.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
    publisher.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = {
    home.packages = [ pkg.run ]
      ++ lib.optionals cfg.photo.enable [ pkg.photo ]
      ++ lib.optionals cfg.designer.enable [ pkg.designer ]
      ++ lib.optionals cfg.publisher.enable [ pkg.publisher ];

    xdg.desktopEntries = {
      ${if cfg.photo.enable then "photo" else null} = {
        name = "Affinity Photo";
        genericName = "Image Editor";
        exec = "/home/${settings.user.username}/.nix-profile/bin/affinity-photo";
        terminal = false;
        categories = [ "Utility" ];
      };
      ${if cfg.designer.enable then "designer" else null} = {
        name = "Affinity Designer";
        genericName = "Vector Graphics editor";
        exec = "/home/${settings.user.username}/.nix-profile/bin/affinity-designer";
        terminal = false;
        categories = [ "Utility" ];
      };
      ${if cfg.publisher.enable then "publisher" else null} = {
        name = "Affinity Publisher";
        genericName = "";
        exec = "/home/${settings.user.username}/.nix-profile/bin/affinity-publisher";
        terminal = false;
        categories = [ "Utility" ];
      };
    };
  };
}

