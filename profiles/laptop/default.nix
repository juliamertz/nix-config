{
  pkgs,
  settings,
  dotfiles,
  helpers,
  ...
}:
{
  system = {
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
      nonUS.remapTilde = true;
    };

    defaults = {
      trackpad.Clicking = true;
      NSGlobalDomain = {
        # disable natural scrolling
        "com.apple.swipescrolldirection" = false;
      };

      dock = {
        autohide = true;
        autohide-delay = 0.0;
        expose-animation-duration = 0.0;
        orientation = "right";
        minimize-to-application = true;
      };
    };
  };

  nerdfonts = {
    enable = true;
    enableUnfree = true;
  };

  sops.secrets = helpers.ownedSecrets settings.user.username [
    "hass_token"
  ];

  # disable default zsh shell so we can use wrapped pkg
  programs.zsh.enable = false;
  environment.systemPackages = with dotfiles.pkgs; [
    scripts
    zsh
    neovim
    kitty
    lazygit
    tmux
    w3m
  ];

  system.stateVersion = 4;

  imports = [
    # apps
    ../../modules/apps/browser/librewolf
    ../../modules/apps/git.nix
    ../../modules/apps/media/spotify.nix

    # window manager
    ../../modules/wm/yabai

    # system components
    ../../modules/nerdfonts.nix
    ../../modules/sops.nix
    ../../modules/homebrew.nix
  ];
}
