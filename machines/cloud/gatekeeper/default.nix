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
      neovim-minimal
      lazygit
    ];
  };

  imports = [
    ./hardware.nix

    ../bootloader.nix
    # ../../../modules/sops.nix
  ];
}
