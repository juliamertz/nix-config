{
  description = "My nixos configuration";

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
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-24_05";
    };
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

    affinity = { url = "github:juliamertz/affinity-nixos/main"; };
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
        home = "/home/${userSettings.username}";
        dotfiles = "${userSettings.home}/dotfiles";
      };

      nixpkgs = inputs.nixpkgs-24_05;
      getSpecialArgs = hostname: platform:
        let pkgs = nixpkgs.legacyPackages.${platform};
        in with pkgs; {
          inherit inputs;
          settings = {
            user = userSettings;
            system = {
              inherit hostname platform;
              timeZone = "Europe/Amsterdam";
              defaultLocale = "en_US.UTF-8";
            };
          };
          helpers = callPackage ./helpers { inherit platform; };
          dotfiles = callPackage ./modules/dotfiles.nix {
            repo = "https://github.com/juliamertz/dotfiles";
            rev = "3f8beb143147b3a2868f8a04948957487f39eafe";
            local = {
              enable = false; # when set to true use --impure
              path = userSettings.dotfiles;
            };
          };
        };
    in {
      nixosConfigurations = with nixpkgs.lib;
        let
          base = [
            ./hardware-configuration.nix
            ./profiles/base.nix
            ./modules/home-manager.nix
          ];
        in {

          workstation = nixosSystem {
            specialArgs = getSpecialArgs "workstation" "x86_64-linux";
            modules = base
              ++ [ ./profiles/personal.nix ./hardware/workstation.nix ];
          };

          homelab = nixosSystem {
            specialArgs = getSpecialArgs "homelab" "x86_64-linux";
            modules = base
              ++ [ ./profiles/personal.nix ./hardware/workstation.nix ];
          };
        };

      darwinConfigurations = with nix-darwin.lib; {
        macbookpro = darwinSystem {
          inherit specialArgs;
          modules = [ ./profiles/laptop.nix ./modules/home-manager.nix ];
        };
      };
    };
}
