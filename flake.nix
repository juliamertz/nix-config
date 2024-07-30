{
  description = "My nixos configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-24_05.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-23_11.url = "github:NixOS/nixpkgs/nixos-23.11";

    affinity.url = "github:juliamertz/affinity-nixos/main";
    wezterm.url = "github:wez/wezterm?dir=nix";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    suyu = {
      url = "git+https://git.suyu.dev/suyu/nix-flake";
      inputs.nixpkgs.follows = "nixpkgs-24_05";
    };
    flake-programs-sqlite = {
      url = "github:wamserma/flake-programs-sqlite";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nix-darwin, ... }@inputs:
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

      dotfiles = pkgs.callPackage ./system/dotfiles.nix {
        repo = "https://github.com/juliamertz/dotfiles";
        rev = "6b6e8b5ba2165c3af7067ab2bab37f13e756c86d";
        local = {
          # When set to true the configuration has to be built with --impure
          enable = true;
          path = userSettings.dotfiles;
        };
      };

      lib = nixpkgs.lib;
      pkgs = nixpkgs.legacyPackages.${systemSettings.platform};
      settings = {
        user = userSettings;
        system = systemSettings;
      };
      helpers = pkgs.callPackage ./helpers { };

      specialArgs = {
        inherit inputs;
        inherit dotfiles;
        inherit settings;
        inherit helpers;
      };
    in {
      nixosConfigurations = {
        ${settings.system.hostname} = lib.nixosSystem {
          system = systemSettings.platform;
          inherit specialArgs;
          modules = let
            profile = systemSettings.profile;
            hardware = systemSettings.hardware;
          in [
            ./hardware-configuration.nix
            ./profiles/base.nix
            ./system/home-manager.nix
            (./. + "/profiles" + ("/" + profile) + "/configuration.nix")
            (./. + "/hardware" + ("/" + hardware) + ".nix")
            inputs.flake-programs-sqlite.nixosModules.programs-sqlite
          ];
        };
      };
    };
}
