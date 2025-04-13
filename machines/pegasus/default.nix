{
  pkgs,
  settings,
  dotfiles,
  helpers,
  ...
}: {
  imports = [
    ../../base/darwin.nix
    ./hardware.nix

    ../../modules/apps/media/spotify.nix

    # window manager
    ../../modules/wm/yabai

    # system components
    ../../modules/nerdfonts.nix
    ../../modules/sops.nix
    ../../modules/homebrew.nix
  ];

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
        AppleInterfaceStyle = "Dark";
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

  homebrew = {
    casks = [
      "discord"
      "zerotier-one"
    ];
    masApps = {
      "wireguard" = 1451685025;
    };
  };

  home-manager.users.julia = {
    imports = [
      ../../home/julia/librewolf.nix
      ../../home/julia/git.nix
    ];
  };

  system.stateVersion = 4;
}
