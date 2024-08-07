{ pkgs, settings, ... }: {
  imports = [
    ../../system/containers/home-assistant.nix
    ../../system/containers/sponsorblock-atv.nix
    ../../system/networking/zerotier # Vpn tunnel
    ../../system/sops.nix # Secrets management
    ../../system/apps/git.nix
    ../../system/apps/terminal/tmux.nix
    ../../system/apps/shell/zsh.nix
    ../../system/apps/neovim.nix
    ../../system/apps/lazygit.nix
    ../../system/lang/lua.nix 
  ];

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  nixpkgs.config.allowUnfree = true;
  secrets.profile = "personal";

  environment.systemPackages = [ ];
}
