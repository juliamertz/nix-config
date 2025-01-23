{ pkgs, lib, settings, ... }:
let
  inherit (settings.user) username fullName;
  inherit (settings.system) platform hostname;
in
{
  config = {
    environment.systemPackages = with pkgs; [
      openssl
      curl
      tldr
      zip
      unzip
      nixfmt-rfc-style
    ];

    nixpkgs.config.allowUnfree = true;
    nix.settings.experimental-features = lib.mkDefault [
      "nix-command"
      "flakes"
      "pipe-operators"
    ];

    nixpkgs.hostPlatform = platform;
    networking.hostName = hostname;

    users.users.${username} = {
      description = fullName;
      inherit (settings.user) home;
    };
  };
}
