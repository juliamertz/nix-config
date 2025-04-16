{
  lib,
  helpers,
  dotfiles,
  ...
}: {
  options = with lib; {
    zsh.environmentVariables = mkOption {
      type = types.setType;
      default = {};
    };
  };

  config = lib.mkMerge [
    (lib.optionalAttrs helpers.isLinux {
      programs.zsh.enable = true;
    })
    {
      environment.systemPackages = [dotfiles.pkgs.zsh];
      programs.direnv = {
        enable = true;
        silent = true;
        nix-direnv.enable = true;
      };
    }
  ];
}
