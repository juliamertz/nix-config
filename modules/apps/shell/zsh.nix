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

  inherit (helpers) isDarwin;
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
          environment.shells = [ pkgs.zsh ];

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
      programs.zsh.enable = true;
      environment.systemPackages = dependencies;
      programs.direnv = {
        enable = true;
        silent = true;
        nix-direnv.enable = true;
      };
    }
  ];

}
