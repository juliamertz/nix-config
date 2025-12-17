{
  pkgs,
  inputs,
  ...
}: let
  pkgs-25_05 = import inputs.nixpkgs-25_05 {
    inherit (pkgs.stdenv.hostPlatform) system;
    config.allowUnfree = true;
  };
in {
  # Game streaming
  services.sunshine = {
    enable = false;
    openFirewall = true;
    autoStart = true;
    capSysAdmin = true; # enable for wayland

    package = pkgs.sunshine.override {
      cudaSupport = true;
      stdenv = pkgs.cudaPackages.backendStdenv;
    };
  };

  programs.steam = {
    enable = true;
    package = pkgs-25_05.steam;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  environment.systemPackages = with pkgs; [
    # Wine stuff
    protontricks
    winetricks
    wine

    # Game launchers
    prismlauncher
    pkgs-25_05.lutris
    # inputs.suyu.packages.x86_64-linux.suyu

    # Misc
    mangohud
    gamescope
    gamemode
    discord
  ];
}
