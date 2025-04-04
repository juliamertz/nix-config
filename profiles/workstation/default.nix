{
  pkgs,
  inputs,
  dotfiles,
  ...
}:
{
  config = {
    secrets.profile = "personal";
    users.defaultUserShell = pkgs.zsh;

    # open ports for development
    networking.firewall.allowedTCPPorts = [
      1111
      1112
    ];

    nerdfonts = {
      enable = true;
      enableUnfree = true;
    };

    environment.variables = {
      BROWSER = "librewolf";
      TERMINAL = "kitty";
    };

    environment.systemPackages =
      (with dotfiles.pkgs; [
        scripts
        tmux
        neovim
        lazygit
        kitty
        w3m
        weechat
        zathura
      ])
      ++ (with pkgs; [
        ripgrep # find
        repgrep # replace
        emote # gtk emote picker popup
        gpu-screen-recorder-gtk
        qdirstat # disk space explorer
        btop # resource monitor
        fastfetch
        mpv # video player
        scrot # screenshot utility
        sxiv # image viewer

        # misc utils
        xorg.xhost
        networkmanagerapplet
        usbutils
        ethtool
      ]);
  };

  imports = [
    ./gaming

    ../../modules/networking/zerotier
    ../../modules/io/bluetooth.nix
    ../../modules/io/pipewire.nix
    ../../modules/sops.nix

    # desktop environment
    ../../modules/wm/awesome
    ../../modules/dm/sddm.nix
    ../../modules/wm/hyprland
    ../../modules/io/keyd.nix
    ../../modules/themes/rose-pine

    # apps
    ../../modules/apps/browser/librewolf
    ../../modules/apps/media/spotify.nix
    ../../modules/apps/virtmanager.nix
    ../../modules/apps/git.nix
    ../../modules/apps/shell/zsh.nix
    ../../modules/networking/samba/client.nix
    ../../modules/nerdfonts.nix
    ../../modules/apps/thunar.nix
    ../../modules/apps/ollama.nix
    ../../modules/containers/default.nix
    # ../../modules/de/cosmic

    inputs.stylix.nixosModules.stylix
  ];

}
