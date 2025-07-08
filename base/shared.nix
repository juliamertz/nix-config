{
  pkgs,
  lib,
  settings,
  inputs,
  helpers,
  ...
}: let
  unstable = helpers.getPkgs inputs.nixpkgs-unstable;
  inherit (lib) mkDefault;
  inherit (settings.user) username fullName home;
  inherit (settings.system) platform hostname;
in {
  imports = [../modules/settings.nix];

  config = {
    nixpkgs.overlays = [
      (self: super: {
        fetchGist = opts:
          pkgs.fetchurl {
            url = with opts; "https://gist.githubusercontent.com/${id}/raw/${rev}/${file}";
            inherit (opts) hash;
          };
      })
    ];

    environment.systemPackages = with pkgs; [
      tealdeer
      cachix
      openssl
      curl
      fd
      skim
    ];

    nixpkgs.config.allowUnfree = mkDefault true;
    nix = {
      package = unstable.nix;
      settings = {
        experimental-features = mkDefault [
          "nix-command"
          "flakes"
          "pipe-operators"
        ];

        substituters = ["https://juliamertz.cachix.org"];
        trusted-public-keys = [
          "cache.juliamertz.dev-1:Jy4H1rmdG1b9lqEl5Ldy0i8+6Gqr/5DLG90r4keBq+E="
          "juliamertz.cachix.org-1:l9jCGk7vAKU5kS07eulGJiEsZjluCG5HTczsY2IL2aw="
        ];

        trusted-users = [
          "root"
          settings.user.username
        ];
      };
    };

    nixpkgs.hostPlatform = mkDefault platform;
    networking.hostName = mkDefault hostname;

    users.users.${username} = {
      description = fullName;
      inherit home;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBfVB8IMsb81U7ySvg82PTlBhnKlQ7Lqs50p4XU1nAv3"
      ];
    };
  };
}
