{ pkgs, lib, settings, config, ... }:
{
  home.packages = with pkgs; [ tmux git ];

  home.activation.tmuxPluginManager = lib.hm.dag.entryAfter [ "writeBoundary" ] /* sh */ ''
      TARGET_DIR=${settings.user.home}/tmux/plugins/tpm
      REPO=https://github.com/tmux-plugins/tpm
      
      if [ ! -e "$TARGET_DIR" ]; then
        mkdir -p $TARGET_DIR;
        ${pkgs.git}/bin/git clone --depth=1 --single-branch $REPO $TARGET_DIR;
      fi
      nix-shell -p tmux git --run "$TARGET_DIR/bin/install_plugins"
  '';

  home.file.".config/tmux" = {
    source = "${config.dotfiles.path}/tmux";
    recursive = true;
  };
}
