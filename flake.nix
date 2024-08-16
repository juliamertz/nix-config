{
  description = "My nixos configuration";

  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-24_05.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-23_11.url = "github:NixOS/nixpkgs/nixos-23.11";

    affinity = { url = "github:juliamertz/affinity-nixos/main"; };
    wezterm = { url = "github:wez/wezterm?dir=nix"; };
    sops-nix = { url = "github:Mic92/sops-nix"; };
    stylix = { url = "github:danth/stylix"; };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-24_05";
    };
    suyu = {
      url = "git+https://git.suyu.dev/suyu/nix-flake";
      inputs.nixpkgs.follows = "nixpkgs-24_05";
    };
    flake-programs-sqlite = {
      url = "github:wamserma/flake-programs-sqlite";
      inputs.nixpkgs.follows = "nixpkgs-24_05";
    };
    vpnconfinement = {
      url = "github:Maroka-chan/VPN-Confinement";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = { self, home-manager, ... }@inputs:
    let
      userSettings = {
        username = "julia";
        fullName = "Julia Mertz";
        email = "info@juliamertz.dev";
        shell = "zsh";
        browser = "firefox";
        terminal = "wezterm";
        editor = "nvim";
        windowManager = "awesome";
        home = "/home/${userSettings.username}";
        dotfiles = "${userSettings.home}/dotfiles";
      };

      systemSettings = {
        profile = "personal";
        hostname = "workstation";
        hardware = systemSettings.hostname;

        term = "xterm-256color";
        platform = "x86_64-linux";
        timeZone = "Europe/Amsterdam";
        defaultLocale = "en_US.UTF-8";
      };

      dotfiles = pkgs.callPackage ./modules/dotfiles.nix {
        repo = "https://github.com/juliamertz/dotfiles";
        rev = "09f6b366185f4eb917d39d4072ab60a6d90b440f";
        local = {
          # When set to true the configuration has to be built with --impure
          enable = false;
          path = userSettings.dotfiles;
        };
      };

      nixpkgs = inputs.nixpkgs-24_05;
      pkgs = nixpkgs.legacyPackages.${systemSettings.platform};
      helpers = pkgs.callPackage ./helpers { inherit settings; };
      settings = {
        user = userSettings;
        system = systemSettings;
      };

      specialArgs = {
        inherit inputs;
        inherit dotfiles;
        inherit settings;
        inherit helpers;
      };
    in {
      nixosConfigurations = {
        ${settings.system.hostname} = nixpkgs.lib.nixosSystem {
          system = systemSettings.platform;
          inherit specialArgs;
          modules = let
            profile = systemSettings.profile;
            hardware = systemSettings.hardware;
          in [
            ./hardware-configuration.nix
            ./profiles/base.nix
            ./modules/home-manager.nix
            (./. + "/profiles" + ("/" + profile) + "/configuration.nix")
            (./. + "/hardware" + ("/" + hardware) + ".nix")
            inputs.flake-programs-sqlite.nixosModules.programs-sqlite
          ];
        };
      };
    };
}
