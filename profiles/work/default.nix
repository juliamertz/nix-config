{
  pkgs,
  settings,
  dotfiles,
  ...
}:
let
  scripts = import ../../modules/scripts { inherit pkgs; };
  user = settings.user.username;
in
{
  config = {
    secrets.profile = "work";
    users.users.${user}.initialPassword = "123";

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
      (with scripts; [
        dev
        comma
      ])
      ++ (with dotfiles.pkgs; [
        neovim
        lazygit
        tmux
        kitty
      ])
      ++ (with pkgs; [
        xorg.xhost
        networkmanagerapplet
        librewolf
        chromium
        gh
      ]);

    # enable dynamically linked binaries for mason in neovim
    programs.nix-ld = {
      enable = true;
      libraries = with pkgs; [ stdenv.cc.cc ];
    };

    nix.settings = {
      substituters = [ "https://cosmic.cachix.org/" ];
      trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
    };

    services.displayManager.cosmic-greeter.enable = true;
  };

  imports = [
    # desktop & login manager
    ../../modules/de/cosmic
    # ../../modules/dm/sddm
    # ../../modules/wm/awesome

    ../../modules/io/bluetooth.nix
    ../../modules/io/pipewire.nix
    # remap caps to esc
    ../../modules/io/keyd.nix
    # secrets management
    ../../modules/sops.nix

    # devtools
    ../../modules/apps/git.nix
    ../../modules/apps/shell/zsh.nix
    ../../modules/nerdfonts.nix
  ];

}
