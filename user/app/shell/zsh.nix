{ pkgs, settings, ... }:
let 
  user = settings.user.username;
in {
  # programs.zsh = {
  #   enable = true;
    # promptInit = /*sh*/''
    #   echo hello world
    # '';
  # };

  home.packages = with pkgs; [ zsh ];
  home.file.".zshrc".text = /*sh*/ ''
    export PATH="$NIX_LINK/bin:/nix/var/nix/profiles/default/bin:$PATH"
    export PATH="/etc/profiles/per-user/${user}/bin:$PATH"
    export PATH="/run/current-system/sw/bin:$PATH"
  '';
}
