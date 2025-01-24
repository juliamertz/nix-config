{
  pkgs,
  lib,
  settings,
  inputs,
  helpers,
  ...
}:
let
  unstable = helpers.getPkgs inputs.nixpkgs-unstable;
  inherit (lib) mkDefault;
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

    nixpkgs.config.allowUnfree = mkDefault true;
    nix = {
      trusted-users = [
        "root"
        settings.user.username
      ];
      trusted-public-keys = [ "cache.juliamertz.dev-1:Jy4H1rmdG1b9lqEl5Ldy0i8+6Gqr/5DLG90r4keBq+E=" ];
      package = unstable.nix;
      settings.experimental-features = mkDefault [
        "nix-command"
        "flakes"
        "pipe-operators"
      ];
    };

    nixpkgs.hostPlatform = platform;
    networking.hostName = hostname;

    users.users.${username} = {
      description = fullName;
      inherit (settings.user) home;
    };
  };
}
