{ lib, pkgs, settings, config, ... }:
let 
  cfg = config.dotfiles;
  pkg = pkgs.stdenvNoCC.mkDerivation {
    installPhase = ''
      cp -aR $src $out
    '';
    pname = "dotfiles";
    version = "0.0.1";
    dontBuild = true;
    src = builtins.fetchGit {
      url = "https://github.com/juliamertz/dotfiles";
      rev = cfg.rev;
    };
  };
in {
  options = {
    dotfiles = {
      rev = lib.mkOption {
        type = lib.types.str;
        default = "75b211bec64532922feec4d080de9310fb877ab5";
        description = "Revision of dotfiles repo to use";
      }; 
      local.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Wether to use local dotfiles or from a remote repo
          If set to false build your home config with `--impure`
        '';
      }; 
      local.path = lib.mkOption {
        type = lib.types.str;
        default = "${settings.user.home}/dotfiles";
        description = "Path to local dotfiles directory";
      }; 
      path = lib.mkOption {
        type = lib.types.str; 
        readOnly = true;
        description = "Readonly nix store path to dotfiles";
      };
    };
  };  
  config = {
    dotfiles.path = if cfg.local.enable then cfg.local.path else builtins.toString pkg;

    environment.systemPackages = []
      ++ lib.optional (!cfg.local.enable) pkg;
  };
}
