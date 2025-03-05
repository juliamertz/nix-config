{
  dotfiles,
  ...
}:
{
  config = {
    settings = {
      timeZone = "Europe/Berlin";
      locale = "en_US.utf-8";
    };

    secrets = {
      profile = "vps";
      activationScript = false;
    };

    openssh = {
      enable = true;
      harden = true;
    };

    environment.systemPackages = with dotfiles.pkgs; [
      zsh
      tmux
      neovim
      lazygit
    ];
  };

  imports = [
    ./wiregaurd.nix
    ./caddy.nix

    ../../modules/apps/git.nix
    ../../modules/sops.nix
  ];
}
