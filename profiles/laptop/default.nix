{
  pkgs,
  inputs,
  settings,
  dotfiles,
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

  environment.systemPackages =
    with pkgs;
    [
      sops
      tldr
      yq
      openvpn
      inputs.protonvpn-rs.packages.${settings.system.platform}.protonvpn-rs
    ]
    ++ (with dotfiles.pkgs; [
      neovim
      lazygit
      tmux
    ]);

  system.stateVersion = 4;

  imports = [
    ../../modules/apps/terminal/wezterm.nix
    ../../modules/apps/terminal/kitty.nix
    ../../modules/apps/shell/zsh.nix
    ../../modules/apps/git.nix
    ../../modules/lang/rust.nix
    ../../modules/lang/nix.nix
    ../../modules/lang/go.nix
    ../../modules/apps/browser/firefox.nix
    ../../modules/wm/yabai
    ../../modules/nerdfonts.nix

    # ../modules/sops.nix
    # ../modules/apps/media/spotify
  ];
}
