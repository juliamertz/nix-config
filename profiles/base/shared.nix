{
  pkgs,
  lib,
  settings,
  inputs,
  helpers,
  ...
}:
let
  inherit (settings.user) username fullName;
  inherit (settings.system)
    platform
    hostname
    timeZone
    defaultLocale
    ;
in
{
  config = {
    environment.systemPackages = with pkgs; [
      openssl
      curl
      tldr
      zip
      unzip
    ];
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    nixpkgs.hostPlatform = platform;
    networking.hostName = hostname;

    users.users.${username} = {
      description = fullName;
      home = settings.user.home;
    };
  };
}
