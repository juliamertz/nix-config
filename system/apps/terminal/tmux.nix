{ pkgs, dotfiles, helpers, settings, ... }:
let
    # installPhase = ''
    #   mkdir -p $TMPDIR/tmux/plugins
    #   cp -aR ${tpmSrc} $TMPDIR/tmux/plugins/tpm
    #   echo "TMPDIR structure:"
    #   ls -R $TMPDIR
    #   cd $TMPDIR/tmux/plugins
    #   ${pkgs.bash}/bin/bash ./tpm/bin/install_plugins
    #   cp -aR $TMPDIR/tmux $out/tmux
    # '';

   tpm = pkgs.fetchFromGitHub {
     owner = "tmux-plugins";
     repo = "tpm";
     rev = "7bdb7ca33c9cc6440a600202b50142f401b6fe21";
     sha256 = "sha256-CeI9Wq6tHqV68woE11lIY4cLoNY8XWyXyMHTDmFKJKI=";
  };
  tmux = helpers.wrapPackage {
    name = "tmux";
    package = pkgs.tmux;
    extraArgs =  "--set XDG_CONFIG_HOME '${settings.user.home}/.config'";
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
  home.file.".config/tmux/plugins/tpm" = {
    source = tpm;
    recursive = true;
  };
}
