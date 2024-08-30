{ pkgs, lib, helpers, dotfiles, config, ... }:
let
  cfg = config.zsh;
  environmentVariables = helpers.formattedEnvVars { EDITOR = "nvim"; };
  dependencies = with pkgs; [ bat jq zoxide ];
  zsh = helpers.wrapPackage {
    inherit dependencies;
    name = "zsh";
    package = pkgs.zsh;
    extraArgs = "--set ZDOTDIR '${dotfiles.path}/zsh' " + environmentVariables;
  };
in {
  options = with lib; {
    zsh.environmentVariables = mkOption {
      type = types.setType;
      default = { };
    };
  };
  config = {
    home.file.".config/zsh" = lib.mkIf helpers.isDarwin {
      source = "${dotfiles.path}/zsh";
      recursive = true;
    };

    environment.systemPackages = [ ] ++ lib.optionals helpers.isLinux [ zsh ]
      ++ lib.optionals helpers.isDarwin dependencies;

    programs.direnv = {
      enable = true;
      silent = true;
      nix-direnv.enable = true;
    };
  };
}
