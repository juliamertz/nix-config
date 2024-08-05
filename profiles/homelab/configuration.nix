{ pkgs, ... }: {
  imports = [
    # ../../system/containers/home-assistant.nix
    ../../system/networking/zerotier # Vpn tunnel
    ../../system/containers/sponsorblock-atv.nix
    ../../system/networking/zerotier # Vpn tunnel
    ../../system/sops.nix # Secrets management
    ../../system/apps/git.nix
    ../../system/apps/terminal/tmux.nix
    ../../system/apps/shell/zsh.nix
    ../../system/apps/neovim.nix
  ];

  users.defaultUserShell = pkgs.zsh;
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = [ ];
}
