{pkgs, ...}: {
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
    lutris
    # inputs.suyu.packages.x86_64-linux.suyu

    # Misc
    mangohud
    discord
  ];
}
