{ pkgs, config, ... }:
{
  home.packages = with pkgs; [ lazygit delta ];

  home.file.".config/lazygit" = {
    source = "${config.dotfiles.path}/lazygit";
    recursive = true;
  };
}

