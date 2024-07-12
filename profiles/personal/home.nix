{ config, pkgs, options, ... }:
let shellAliases = {
  cat = "bat -pp";
  lg = "lazygit";
  sctl = "sudo systemctl";
  vpn = "protonvpn-cli";
  spt = "spotify_player";
};
in
{
  home.username = "julia";
  home.homeDirectory = "/home/julia";

  programs.home-manager.enable = true;

  imports = [
    ../../user/app/browser/firefox.nix
    ../../user/wm/awesome/home.nix
    ../../user/wm/picom/picom.nix
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

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };


  programs.fish = {
    inherit shellAliases;
    enable = true;
  };

  # xsession.windowManager.awesome = {
  #   enable = true;
  #   luaModules = with pkgs.luaPackages; [ luarocks ];
  # };

  # home.file."~/.config/awesome/rc.lua".source = ./config/rc.lua;

  home.stateVersion = "24.05";
}
