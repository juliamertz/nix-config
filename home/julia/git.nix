{inputs, ...}: {
  programs.git = {
    enable = true;
  };

  # prefer linking configuration directly so other applications
  # like lazygit can still write to the gitconfig directories
  home.file.".gitconfig".source = "${inputs.dotfiles}/git/.gitconfig";
}
