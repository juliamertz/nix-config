{ pkgs, config, ... }:
{
  home.packages = with pkgs; [ ripgrep ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
  };

  home.file.".config/nvim" = {
    source = "${config.dotfiles.path}/nvim";
    recursive = true;
  };
}
