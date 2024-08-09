{ pkgs, lib, helpers, dotfiles, config, ... }:
let
  cfg = config.zsh;
  environmentVariables = helpers.formattedEnvVars { EDITOR = "nvim"; };
  zsh = helpers.wrapPackage {
    name = "zsh";
    package = pkgs.zsh;
    extraArgs = "--set ZDOTDIR '${dotfiles.path}/zsh' " + environmentVariables;
    dependencies = with pkgs; [ bat jq zoxide ];
  };
in {
  options = with lib; {
    zsh.environmentVariables = mkOption {
      type = types.setType;
      default = { };
    };
  };
  config = { environment.systemPackages = [ zsh ]; };
}
