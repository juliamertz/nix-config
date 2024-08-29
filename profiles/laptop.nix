{ pkgs, inputs, settings, ... }: {
  imports = [
    ../modules/homebrew.nix

    ../modules/apps/neovim.nix
    ../modules/apps/lazygit.nix

    ../modules/apps/terminal/wezterm.nix
    ../modules/apps/terminal/tmux.nix
    ../modules/apps/shell/zsh.nix
    ../modules/apps/git.nix

    ../modules/apps/browser/firefox.nix

    # ../modules/sops.nix
    # ../modules/apps/media/spotify
  ];

  environment.systemPackages = with pkgs; [
    sops
    tldr
    yq
    (pkgs.writeShellScriptBin "dr" ''
      #!${pkgs.bash}
      darwin-rebuild ''${1:-"switch"} --flake ''${2:-"."}
    '')
  ];

  services.nix-daemon.enable = true;
  nix.settings.experimental-features = "nix-command flakes";

  users.users.${settings.user.username} = {
    description = settings.user.fullName;
    home = "/Users/${settings.user.username}";
  };

  networking.hostName = settings.system.hostname;

  system.stateVersion = 4;
  nixpkgs.hostPlatform = "aarch64-darwin";
}
