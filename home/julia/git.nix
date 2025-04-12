{inputs, ...}: {
  programs.git.enable = true;
  home.file.".gitconfig".source = "${inputs.dotfiles}/git/config";
}
