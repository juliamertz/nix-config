{
  pkgs,
  inputs,
  settings,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    lutris
    inputs.nixpkgs-23_11.legacyPackages.${settings.system.platform}.gamescope
    # gamescope
    # rpcs3
  ];

  programs.gamescope.enable = true;
  nixpkgs.config.packageOverrides = pkgs: {
    steam = pkgs.steam.override {
      extraPkgs =
        pkgs: with pkgs; [
          xorg.libXcursor
          xorg.libXi
          xorg.libXinerama
          xorg.libXScrnSaver
          libpng
          libpulseaudio
          libvorbis
          stdenv.cc.cc.lib
          libkrb5
          keyutils
        ];
    };
  };
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    gamescopeSession.enable = true;
  };
}
