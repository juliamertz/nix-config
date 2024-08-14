{ pkgs, settings, ... }: {
  imports = [
    ../../modules/containers/home-assistant.nix
    ../../modules/containers/jellyfin.nix
    ../../modules/containers/sponsorblock-atv.nix
    ../../modules/networking/zerotier # Vpn tunnel
    ../../modules/sops.nix # Secrets management
    ../../modules/apps/git.nix
    ../../modules/apps/terminal/tmux.nix
    ../../modules/apps/shell/zsh.nix
    ../../modules/apps/neovim.nix
    ../../modules/apps/lazygit.nix
    ../../modules/lang/lua.nix 
    ../../modules/networking/openvpn # Protonvpn configurations
    ../../modules/apps/qbittorrent.nix
    ../../modules/networking/samba/server.nix
  ];

  jellyfin = let user = settings.user.home; in {
    configDir = "${user}/jellyfin";
    volumes = [
      "${user}/media/shows:/shows"
      "${user}/media/movies:/movies"
      "${user}/media/music:/music"
    ];
  };

  openvpn.proton = {
    enable = true;
    profile = "nl-393";
  };

  services.qbittorrent = {
    enable = true;
    port = 8280;

    user = settings.user.username;
    group = "users";
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
