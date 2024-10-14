{
  pkgs,
  settings,
  ...
}:
let
  inherit (settings.user) username fullName;
  inherit (settings.system)
    platform
    hostname
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
      nixfmt-rfc-style
    ];

    nixpkgs.config.allowUnfree = true;
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    nixpkgs.hostPlatform = platform;
    networking.hostName = hostname;

    users.users.${username} = {
      description = fullName;
      inherit (settings.user) home;
    };
  };
}
