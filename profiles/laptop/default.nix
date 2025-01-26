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
        "com.apple.swipescrolldirection" = false; # disable natural scrolling
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

  sops.secrets = helpers.ownedSecrets settings.user.username [
    "spotify_client_id"
    "hass_token"
  ];

  # disable default zsh shell so we can use wrapped pkg
  programs.zsh.enable = false;

  environment.systemPackages =
    with pkgs;
    [
      sops
      tldr
      yq
      openvpn
    ]
    ++ (with dotfiles.pkgs; [
      scripts
      zsh
      neovim
      kitty
      lazygit
      tmux
      w3m
    ]);

  system.stateVersion = 4;

  imports = [
    ../../modules/apps/git.nix
    ../../modules/lang/rust.nix
    ../../modules/lang/nix.nix
    ../../modules/lang/go.nix
    ../../modules/apps/browser/firefox.nix
    ../../modules/wm/yabai
    ../../modules/nerdfonts.nix
    ../../modules/sops.nix
    ../../modules/apps/media/spotify.nix
  ];
}
