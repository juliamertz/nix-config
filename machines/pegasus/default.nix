{
  inputs,
  pkgs,
  settings,
  dotfiles,
  helpers,
  ...
}: let
  nixpkgs-master = import inputs.nixpkgs-master {
    inherit (pkgs) system;
    config.allowUnfree = true;
  };
in {
  imports = [
    ./hardware.nix
    ./work.nix

    ../../modules/wm/aerospace
    ../../modules/apps/media/spotify.nix
    ../../modules/nerdfonts.nix
    ../../modules/sops.nix
    ../../modules/homebrew.nix
    ../../modules/apps/shell/zsh.nix
    # ../../modules/virtualisation/linux-builder.nix
  ];

  home-manager.users.julia.imports = [
    ../../home/julia/browser/firefox.nix
    ../../home/julia/browser/librewolf.nix
  ];

  system.primaryUser = "julia";

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

  wm.aerospace = {
    enable = true;
    autoStart = true;
    configPath = "${dotfiles.path}/aerospace/config.toml";
  };

  nerdfonts = {
    enable = true;
    enableUnfree = true;
  };

  sops.secrets = helpers.ownedSecrets settings.user.username [
    "hass_token"
  ];

  environment.systemPackages = with dotfiles.pkgs;
    [
      scripts
      neovim
      kitty
      zsh
      lazygit
      (git.override {
        signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOOY+XtPOqEdGLBzzHehlGxYmFRwu/KSqyNM2JQ4veqb";
        use1Password = true;
      })
      tmux
      w3m
    ]
    ++ (with pkgs; [
      devenv
      attic-client
    ]);

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
