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

    nerdfonts.enableUnfree = true;

    environment.systemPackages =
      (with dotfiles.pkgs; [
        scripts
        neovim
        kitty
        wezterm
        lazygit
        tmux
        weechat
        w3m
        zathura
      ])
      ++ (with pkgs; [
        qdirstat
        btop
        fastfetch
        mpv
        scrot
        sxiv
        xorg.xhost
        networkmanagerapplet
        usbutils
        firefox
        gh
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
    ../../modules/apps/virtmanager.nix
    ../../modules/apps/git.nix
    ../../modules/apps/media/spotify.nix
    ../../modules/apps/shell/zsh.nix
    ../../modules/networking/samba/client.nix
    ../../modules/nerdfonts.nix
    ../../modules/lang/lua.nix
    ../../modules/lang/nix.nix
    ../../modules/apps/thunar.nix
    ../../modules/apps/ollama.nix
    # ../modules/apps/browser/librewolf.nix
    # ../../modules/de/cosmic
    # inputs.protonvpn-rs.nixosModules.protonvpn
    inputs.stylix.nixosModules.stylix
  ];

}
