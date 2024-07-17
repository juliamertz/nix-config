{ lib, pkgs, settings, ... }:
let
  user = settings.user.username;
  inherit (pkgs) stdenv;
in {
  home.file.".config/fish/config.fish".text = /*fish*/ ''
    alias lg "lazygit"
    alias sctl "sudo systemctl"
    alias spt "spotify_player"
    alias poweroff "sudo shutdown -h now"
    
    fish_add_path /run/wrappers/bin
    fish_add_path "$NIX_LINK/bin"
    fish_add_path "/nix/var/nix/profiles/default/bin"
    fish_add_path "/etc/profiles/per-user/${user}/bin"
    fish_add_path "/run/current-system/sw/bin"

    function fish_greeting
      fortune | cowsay
    end
  '';

  home.activation = lib.mkIf stdenv.isDarwin {
    setFishAsShell = lib.hm.dag.entryAfter [ "writeBoundary" ] /*sh*/''
      /usr/bin/sudo /usr/bin/dscl . -create /Users/${user} UserShell ${pkgs.fish}/sw/bin/fish
      '';
  };

  home.packages = with pkgs; [ 
    cowsay
    fortune

    fish
    bat
    fzf
    jq
    yq
    ripgrep
    grc
    tldr
  ]; 
}
