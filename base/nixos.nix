{
  pkgs,
  settings,
  ...
}: let
  inherit (settings.user) username home;
in {
  imports = [
    ./shared.nix
    ../modules/io/ssh.nix
  ];

  environment.systemPackages = with pkgs; [
    xclip
    zip
    unzip
  ];

  networking.firewall.enable = true;
  networking.networkmanager.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "${home}/nix-config";
  };

  system.stateVersion = "24.05";
}
