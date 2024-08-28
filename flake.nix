{
  description = "My nixos configuration";

  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-24_05.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-23_11.url = "github:NixOS/nixpkgs/nixos-23.11";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs-24_05";
    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
      inputs.nixpkgs.follows = "nixpkgs-24_05";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-24_05";
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };

    affinity = { url = "github:juliamertz/affinity-nixos/main"; };
    sops-nix = { url = "github:Mic92/sops-nix"; };
    stylix = { url = "github:danth/stylix"; };
    zen-browser.url = "github:MarceColl/zen-browser-flake";
    protonvpn-rs = {
      # url = "/home/julia/projects/2024/protonvpn-rs/nix";
      url = "github:juliamertz/protonvpn-rs/feat-killswitch?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    suyu = {
      url = "git+https://git.suyu.dev/suyu/nix-flake";
      inputs.nixpkgs.follows = "nixpkgs-24_05";
    };
    flake-programs-sqlite = {
      url = "github:wamserma/flake-programs-sqlite";
      inputs.nixpkgs.follows = "nixpkgs-24_05";
    };
    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = { self, home-manager, nix-darwin, ... }@inputs:
    let
      # TODO: Remove system specific config from main flake
      userSettings = {
        username = "julia";
        fullName = "Julia Mertz";
        email = "info@juliamertz.dev";
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
        rev = "3f8beb143147b3a2868f8a04948957487f39eafe";
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
          modules = let inherit (systemSettings) profile hardware;
          in [
            ./hardware-configuration.nix
            ./profiles/base.nix
            ./modules/home-manager.nix
            (./. + "/profiles" + ("/" + profile + ".nix"))
            (./. + "/hardware" + ("/" + hardware) + ".nix")
            inputs.flake-programs-sqlite.nixosModules.programs-sqlite
          ];
        };
      };

      darwinConfigurations.macbookpro = nix-darwin.lib.darwinSystem {
        inherit specialArgs;
        modules = [ ./profiles/laptop.nix ./modules/home-manager.nix ];
      };
    };
}
