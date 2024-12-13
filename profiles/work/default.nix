{
  pkgs,
  settings,
  dotfiles,
  ...
}:
{
  config = {
    users.users.nixvm.isNormalUser = true;
    users.users.nixvm.initialPassword = "123";
    users.users.nixvm.group = "nixvm";
    users.groups.nixvm = { };

    secrets.profile = "work";

    environment.variables = {
      XDG_CONFIG_HOME = "/home/nixvm/.config";
    };
    programs.direnv = {
      enable = true;
      silent = true;
      nix-direnv.enable = true;
    };
    users.defaultUserShell = pkgs.zsh;

    # open ports for development
    networking.firewall.allowedTCPPorts = [
      3000
      1111
      5123
      8000
      8080
    ];

    environment.systemPackages =
      let
        scripts = import ../../modules/scripts { inherit pkgs; };
      in
      (with scripts; [
        dev
        comma
      ])
      ++ (with dotfiles.pkgs; [
        neovim
        lazygit
        tmux
      ])
      ++ (with pkgs; [
        xorg.xhost
        networkmanagerapplet
        librewolf
        chromium
        gh
        wezterm
        xterm
        kitty
      ]);

    # enable dynamically linked binaries for mason in neovim
    programs.nix-ld = {
      enable = true;
      libraries = with pkgs; [ stdenv.cc.cc ];
    };
  };

  imports = [
    ../../modules/io/bluetooth.nix
    ../../modules/io/pipewire.nix
    # remap caps to esc
    ../../modules/io/keyd.nix
    # secrets management
    ../../modules/sops.nix
    # desktop & login manager
    ../../modules/wm/awesome
    ../../modules/dm/sddm
    # ../../modules/wm/hyprland
    # ../../modules/de/plasma

    # devtools
    ../../modules/apps/git.nix
    # ../../modules/apps/terminal/wezterm.nix
    ../../modules/apps/shell/zsh.nix
    ../../modules/nerdfonts.nix
  ];

}
