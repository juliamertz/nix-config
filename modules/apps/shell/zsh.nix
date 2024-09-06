{
  pkgs,
  lib,
  helpers,
  dotfiles,
  config,
  settings,
  ...
}:
let
  cfg = config.zsh;
  environmentVariables = helpers.formattedEnvVars { EDITOR = "nvim"; };
  dependencies = with pkgs; [
    bat
    jq
    zoxide
  ];
  zsh = helpers.wrapPackage {
    name = "zsh";
    package = pkgs.zsh;
    extraArgs = "--set ZDOTDIR '${dotfiles.path}/zsh' " + environmentVariables;
  };

  inherit (helpers) isLinux isDarwin;
  inherit (lib) optionals mkIf;
in
{
  options = with lib; {
    zsh.environmentVariables = mkOption {
      type = types.setType;
      default = { };
    };
  };

  config = lib.mkMerge [
    (
      if helpers.isDarwin then
        {
          programs.zsh.enable = true;

          home.file.".zshrc".source = "${dotfiles.path}/zsh/.zshrc";
          home.file.".config/zsh" = {
            source = "${dotfiles.path}/zsh";
            recursive = true;
          };

          environment.variables = {
            ZDOTDIR = "${settings.user.home}/.config/zsh";
          };
        }
      else
        { environment.systemPackages = [ zsh ]; }
    )
    {
      environment.systemPackages = dependencies;
      programs.direnv = {
        enable = true;
        silent = true;
        nix-direnv.enable = true;
      };
    }
  ];

}
