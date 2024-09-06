{
  pkgs,
  lib,
  config,
  dotfiles,
  helpers,
  settings,
  ...
}:
let
  # tpm = pkgs.fetchFromGitHub {
  #   owner = "tmux-plugins";
  #   repo = "tpm";
  #   rev = "7bdb7ca33c9cc6440a600202b50142f401b6fe21";
  #   sha256 = "sha256-CeI9Wq6tHqV68woE11lIY4cLoNY8XWyXyMHTDmFKJKI=";
  # };
  tmux = helpers.wrapPackage {
    name = "tmux";
    package = pkgs.tmux;
    extraArgs = "--set XDG_CONFIG_HOME '${settings.user.home}/.config'";
    extraFlags = "-f ${settings.user.home}/.config/tmux/tmux.conf";
    dependencies = with pkgs; [ fzf ];
  };
in
{
  environment.systemPackages = [ tmux ];
  home.file.".config/tmux" = {
    source = "${dotfiles.path}/tmux";
    recursive = true;
  };

  # home.activation.tmuxPluginManager =
  #   # bash 
  #   ''
  #     TARGET_DIR=${settings.user.home}/tmux/plugins/tpm
  #     REPO=https://github.com/tmux-plugins/tpm
  #     if [ ! -e "$TARGET_DIR" ]; then
  #       mkdir -p $TARGET_DIR;
  #       ${pkgs.git}/bin/git clone --depth=1 --single-branch $REPO $TARGET_DIR;
  #     fi
  #     nix-shell -p tmux git --run "$TARGET_DIR/bin/install_plugins"
  #   '';

}
