{dotfiles, ...}: {
  config = {
    settings = {
      timeZone = "Europe/Berlin";
      locale = "en_US.utf-8";
    };

    # secrets = {
    #   profile = "vps";
    #   activationScript = false;
    # };

    openssh = {
      enable = true;
      harden = true;
    };

    environment.systemPackages = with dotfiles.pkgs; [
      git
      zsh
      tmux
      neovim
      lazygit
    ];
  };

  imports = [
    ../base.nix
    ./disks.nix

    # ../../../modules/sops.nix
  ];
}
