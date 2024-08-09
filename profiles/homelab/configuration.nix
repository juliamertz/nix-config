{ pkgs, settings, ... }: {
  imports = [
    ../../system/containers/home-assistant.nix
    ../../system/containers/jellyfin.nix
    ../../system/containers/sponsorblock-atv.nix
    ../../system/networking/zerotier # Vpn tunnel
    ../../system/sops.nix # Secrets management
    ../../system/apps/git.nix
    ../../system/apps/terminal/tmux.nix
    ../../system/apps/shell/zsh.nix
    ../../system/apps/neovim.nix
    ../../system/apps/lazygit.nix
    ../../system/lang/lua.nix 
    ../../system/networking/openvpn # Protonvpn configurations
    ../../system/apps/qbittorrent.nix
  ];

  jellyfin = let user = settings.user.home; in {
    configDir = "${user}/jellyfin";
    volumes = [
      "${user}/media/shows:/shows"
      "${user}/media/movies:/movies"
    ];
  };

  openvpn.proton = {
    enable = true;
    profile = "nl-393";
  };

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  nixpkgs.config.allowUnfree = true;
  secrets.profile = "personal";

  environment.systemPackages = with pkgs; [
    btop
    fastfetch
  ];
}
