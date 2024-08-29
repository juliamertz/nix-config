{ pkgs, inputs, settings, ... }: {
  system = {
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
      nonUS.remapTilde = true;
    };
    defaults = {
      dock = {
        autohide = true;
        autohide-delay = 0.0;
        expose-animation-duration = 0.0;

        orientation = "right";
        minimize-to-application = true;
      };

      trackpad.Clicking = true;

      NSGlobalDomain = {
        "com.apple.swipescrolldirection" = false; # disable natural scrolling
      };
    };
  };

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
    home = settings.user.home;
  };

  networking.hostName = settings.system.hostname;
  nixpkgs.hostPlatform = settings.system.platform;

  system.stateVersion = 4;

  imports = [
    ../modules/homebrew.nix

    ../modules/apps/neovim.nix
    ../modules/apps/lazygit.nix

    ../modules/apps/terminal/wezterm.nix
    ../modules/apps/terminal/tmux.nix
    ../modules/apps/shell/zsh.nix

    ../modules/apps/git.nix
    ../modules/lang/rust.nix
    ../modules/lang/go.nix

    ../modules/apps/browser/firefox.nix

    # ../modules/sops.nix
    # ../modules/apps/media/spotify
  ];
}
