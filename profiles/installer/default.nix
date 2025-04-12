{
  pkgs,
  settings,
  dotfiles,
  ...
}:
{
  imports = [
    ./base/calamares.nix
    ./desktop/cosmic.nix

    ../../modules/nerdfonts.nix
  ];

  environment.systemPackages = [
    dotfiles.pkgs.kitty
    dotfiles.pkgs.wezterm
    dotfiles.pkgs.zsh
    dotfiles.pkgs.tmux
    dotfiles.pkgs.neovim
    dotfiles.pkgs.lazygit
    dotfiles.pkgs.scripts

    pkgs.brave
    pkgs.librewolf
    pkgs.gparted
    pkgs.testdisk
    pkgs.efibootmgr
  ];

  home-manager.users.nixos.home.stateVersion = "24.05";

  users.defaultUserShell = pkgs.zsh;

  programs.zsh.enable = true;

  nerdfonts = {
    enable = true;
    enableUnfree = true;
  };

  installer-desktop.paths = [
    dotfiles.pkgs.neovim
    dotfiles.pkgs.kitty
    dotfiles.pkgs.wezterm

    pkgs.brave
    pkgs.librewolf
    pkgs.gparted
  ];

  nixpkgs.hostPlatform = settings.system.platform;
}
