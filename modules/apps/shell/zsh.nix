{ pkgs, lib, helpers, dotfiles, config, ... }:
let
  cfg = config.zsh;
  environmentVariables = helpers.formattedEnvVars { EDITOR = "nvim"; };
  dependencies = with pkgs; [ bat jq zoxide ];
  zsh = helpers.wrapPackage {
    name = "zsh";
    package = pkgs.zsh;
    extraArgs = "--set ZDOTDIR '${dotfiles.path}/zsh' " + environmentVariables;
  };
  inherit (helpers) isLinux isDarwin;
  inherit (lib) optionals mkIf;
in {
  options = with lib; {
    zsh.environmentVariables = mkOption {
      type = types.setType;
      default = { };
    };
  };
  config = {
    programs.zsh.enable = isDarwin;
    home.file.".zshrc".source = mkIf isDarwin "${dotfiles.path}/zsh";
    home.file.".config/zsh" = mkIf isDarwin {
      source = "${dotfiles.path}/zsh";
      recursive = true;
    };

    environment.systemPackages = dependencies ++ optionals isLinux [ zsh ];

    programs.direnv = {
      enable = true;
      silent = true;
      nix-direnv.enable = true;
    };
  };
}
