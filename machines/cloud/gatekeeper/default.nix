{
  dotfiles,
  config,
  ...
}: let
  hosts = import ../hosts.nix;
in {
  config = {
    boot.loader.grub.device = "/dev/sda";

    settings = {
      timeZone = "Europe/Berlin";
      locale = "en_US.utf-8";
    };

    openssh = {
      enable = true;
      harden = true;
    };

    gateway = with config.gateway.lib; {
      hostname = "juliamertz.dev";
      services = {
        website = {
          config = redirect "https://github.com/juliamertz";
        };
        jellyfin = {
          subdomain = "watch";
          config = reverseProxy "http://${hosts.hydra.internal}:8096";
        };
      };
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

    ./modules/gateway
    # ../../../modules/sops.nix
  ];
}
