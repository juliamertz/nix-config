{
  description = "My nixos/nix-darwin configuration";

  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-24_05.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-23_11.url = "github:NixOS/nixpkgs/nixos-23.11";

    # Darwin
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs-24_05";
    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
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

    # Misc
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs-24_05";
    };
    protonvpn-rs = {
      # url = "/home/julia/projects/2024/protonvpn-rs/nix";
      url = "github:juliamertz/protonvpn-rs/dev?dir=nix";
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

    # affinity.url = "github:juliamertz/affinity-nixos";
    affinity.url = "/home/julia/projects/2024/affinityCrimes";

    sops-nix = { url = "github:Mic92/sops-nix"; };
    stylix = { url = "github:danth/stylix"; };
    zen-browser.url = "github:MarceColl/zen-browser-flake";
  };

  outputs = { self, home-manager, nix-darwin, ... }@inputs:
    let
      userSettings = {
        username = "julia";
        fullName = "Julia Mertz";
        email = "info@juliamertz.dev";
      };

      nixpkgs = inputs.nixpkgs-24_05;
      getSpecialArgs = { hostname, platform }:
        let
          pkgs = nixpkgs.legacyPackages.${platform};
          helpers = pkgs.callPackage ./helpers { inherit platform; };
          dotfiles = pkgs.callPackage ./modules/dotfiles.nix {
            repo = "https://github.com/juliamertz/dotfiles";
            rev = "3f8beb143147b3a2868f8a04948957487f39eafe";
            local = {
              enable = false;
              path = userSettings.dotfiles;
            };
          };

          homeDir = if helpers.isDarwin then "/Users" else "/home";
          home = "${homeDir}/${userSettings.username}";
        in {
          inherit inputs helpers dotfiles;
          settings = {
            user = userSettings // { inherit home; };
            system = {
              inherit hostname platform;
              timeZone = "Europe/Amsterdam";
              defaultLocale = "en_US.UTF-8";
            };
          };
        };
    in {
      nixosConfigurations = with nixpkgs.lib;
        let base = [ ./profiles/base.nix ./modules/home-manager.nix ];
        in {

          workstation = nixosSystem {
            specialArgs = getSpecialArgs {
              hostname = "workstation";
              platform = "x86_64-linux";
            };
            modules = base
              ++ [ ./profiles/personal.nix ./hardware/workstation.nix ];
          };

          homelab = nixosSystem {
            specialArgs = getSpecialArgs {
              hostname = "homelab";
              platform = "x86_64-linux";
            };
            modules = base ++ [ ./profiles/homelab.nix ./hardware/homelab.nix ];
          };
        };

      darwinConfigurations = with nix-darwin.lib; {
        macbookpro = darwinSystem {
          specialArgs = getSpecialArgs {
            hostname = "macbookpro";
            platform = "aarch64-darwin";
          };
          modules = [ ./profiles/laptop.nix ./modules/home-manager.nix ];
        };
      };
    };
}
