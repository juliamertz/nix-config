{
  pkgs,
  lib,
  helpers,
  dotfiles,
  settings,
  ...
}:
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
        { environment.systemPackages = [ dotfiles.pkgs.zsh ]; }
    )
    {
      programs.zsh.enable = true;
      programs.direnv = {
        enable = true;
        silent = true;
        nix-direnv.enable = true;
      };
    }
  ];
}
