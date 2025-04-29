{
  pkgs,
  settings,
  dotfiles,
  helpers,
  ...
}: {
  imports = [
    ./hardware.nix

    ../../base/darwin.nix
    ../../base/work.nix

    # ../../modules/wm/aerospace
    ../../modules/apps/media/spotify.nix
    ../../modules/nerdfonts.nix
    ../../modules/sops.nix
    ../../modules/homebrew.nix
    ../../modules/apps/shell/zsh.nix
  ];

  home-manager.users.julia.imports = [
    ../../home/julia/librewolf.nix
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

  environment.systemPackages = with dotfiles.pkgs; [
    scripts
    neovim
    kitty
    lazygit
    (git.override {
      signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOOY+XtPOqEdGLBzzHehlGxYmFRwu/KSqyNM2JQ4veqb";
      use1Password = true;
    })
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

  system.stateVersion = 5;
}
