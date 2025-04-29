{
  description = "My nixos/nix-darwin configuration";

  inputs = {
    # nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-unstable.follows = "cosmic/nixpkgs";
    nixpkgs-24_11.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-24_05.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-23_11.url = "github:NixOS/nixpkgs/nixos-23.11";

    # Darwin
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nix-homebrew = {
      url = "github:zhaofengli/nix-homebrew";
      # inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    # Misc
    dotfiles.url = "github:juliamertz/dotfiles";
    nur.url = "github:juliamertz/nur";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # suyu = {
    #   url = "git+https://git.suyu.dev/suyu/nix-flake";
    #   inputs.nixpkgs.follows = "nixpkgs-24_05";
    # };

    rose-pine-cosmic.url = "github:rose-pine/cosmic-desktop";
    protonvpn-rs.url = "github:juliamertz/protonvpn-rs/dev?dir=nix";

    cosmic-comp.url = "github:juliamertz/cosmic-comp";
    cosmic.url = "github:lilyinstarlight/nixos-cosmic";
    cosmic-manager = {
      url = "github:juliamertz/cosmic-manager";
      inputs = {
        nixpkgs.follows = "cosmic/nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
  };

  outputs = {
    nixpkgs-unstable,
    nix-darwin,
    nur,
    ...
  } @ inputs: let
    userSettings = {
      username = "julia";
      fullName = "Julia Mertz";
      email = "info@juliamertz.dev";
    };

    getSpecialArgs = {
      hostname,
      system,
    }: let
      pkgs = nixpkgs-unstable.legacyPackages.${system};
      helpers = pkgs.callPackage ./helpers.nix {};
      dotfiles = {
        pkgs = inputs.dotfiles.packages.${system};
        path = "${inputs.dotfiles}";
      };

      homeDir =
        if helpers.isDarwin
        then "/Users"
        else "/home";
      home = "${homeDir}/${userSettings.username}";
    in {
      inherit
        inputs
        helpers
        dotfiles
        system
        ;
      settings = {
        user =
          userSettings
          // {
            inherit home;
          };
        system = {
          inherit hostname;
          platform = system;
          timeZone = "Europe/Amsterdam";
          defaultLocale = "en_US.UTF-8";
        };
      };
    };
  in {
    nixosConfigurations = with nixpkgs-unstable.lib; let
      base = [
        ./base/nixos.nix
        ./modules/home-manager.nix
      ];
    in {
      # workstation
      orion = nixosSystem {
        modules = base ++ [./machines/orion];
        specialArgs = getSpecialArgs {
          hostname = "orion";
          system = "x86_64-linux";
        };
      };

      # homelab server
      hydra = nixosSystem {
        modules = base ++ [./machines/hydra];
        specialArgs = getSpecialArgs {
          hostname = "hydra";
          system = "x86_64-linux";
        };
      };

      # Use stable branch for vps
      andromeda = inputs.nixpkgs-24_05.lib.nixosSystem {
        specialArgs = getSpecialArgs {
          hostname = "andromeda";
          system = "x86_64-linux";
        };
        modules = [
          ./machines/andromeda
          ./base/nixos.nix
        ];
      };

      # liveboot ISO installer configuration
      nebula = nixosSystem {
        specialArgs = getSpecialArgs {
          hostname = "nebula";
          system = "x86_64-linux";
        };
        modules = base ++ [./machines/nebula];
      };
    };

    darwinConfigurations = with nix-darwin.lib; {
      pegasus = darwinSystem {
        specialArgs = getSpecialArgs {
          hostname = "pegasus";
          system = "aarch64-darwin";
        };
        modules = [
          ./machines/pegasus
          ./modules/home-manager.nix
        ];
      };
    };

    packages = nur.lib.allSystemsPkgs (pkgs: {
      docker-image = pkgs.callPackage ./portable/image.nix {inherit inputs;};
    });

    devShells = nur.lib.allSystems (
      system: let
        pkgs = nixpkgs-unstable.legacyPackages.${system};
      in {
        default = pkgs.mkShellNoCC {
          packages = with pkgs; [
            nixos-generators
            nix-fast-build
            alejandra
            treefmt
          ];
        };
      }
    );
  };
}
