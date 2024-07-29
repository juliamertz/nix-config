{ pkgs, pkgs-wrapped, ... }: {
  imports = [
    ../../system/containers/home-assistant.nix
    ../../system/containers/sponsorblock-atv.nix
    ../../system/networking/zerotier # Vpn tunnel
    ../../system/sops.nix # Secrets management
    ../../system/apps/git.nix
  ];

  users.defaultUserShell = pkgs.bash;
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = [ ]
    ++ (with pkgs-wrapped; [ lazygit nvim kitty tmux ]);
}
