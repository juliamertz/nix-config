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

  nerdfonts.enableUnfree = true;

  sops.secrets = helpers.ownedSecrets settings.user.username [
    "spotify_client_id"
    "hass_token"
  ];

  # disable default zsh shell so we can use wrapped pkg
  programs.zsh.enable = false;
  environment.systemPackages =
    with dotfiles.pkgs;
    [
      scripts
      zsh
      neovim
      kitty
      lazygit
      tmux
      w3m
      spotify
      spotify-player
    ]
    ++ (with pkgs; [
      yq
      openvpn
    ]);

  system.stateVersion = 4;

  imports = [
    ../../modules/apps/git.nix
    ../../modules/apps/browser/firefox.nix
    ../../modules/wm/yabai
    ../../modules/nerdfonts.nix
    ../../modules/sops.nix
  ];
}
