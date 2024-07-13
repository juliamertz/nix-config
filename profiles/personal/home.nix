{ config, pkgs, options, settings, ... }:
let 
  user = settings.user.username;
  shellAliases = {
    cat = "bat -pp";
    lg = "lazygit";
    sctl = "sudo systemctl";
    vpn = "protonvpn-cli";
    spt = "spotify_player";
  };
in
{
  home.username = user;
  home.homeDirectory = "/home/${user}";

  programs.home-manager.enable = true;

  imports = [
    ../../user/app/tools/lazygit.nix
    ../../user/app/browser/firefox.nix
    ../../user/wm/awesome/home.nix
    ../../user/wm/picom/picom.nix
    ../../user/app/terminal/wezterm/home.nix
    ../../user/app/shell/fish.nix
  ];

  home.packages = [
    (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  home.sessionVariables = {
    EDITOR = settings.system.editor; 
  };

  home.stateVersion = "24.05";
}
