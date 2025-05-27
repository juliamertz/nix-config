{
  description = "My nixos/nix-darwin configuration";

  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-24_11.url = "github:NixOS/nixpkgs/nixos-24.11";

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

    rose-pine-cosmic.url = "github:rose-pine/cosmic-desktop";
    protonvpn-rs.url = "github:juliamertz/protonvpn-rs/dev?dir=nix";
    cosmic-comp.url = "github:juliamertz/cosmic-comp";
    cosmic-manager = {
      url = "github:juliamertz/cosmic-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs-unstable";
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
        };
      };
    };

    nixosBase = [
      ./base/nixos.nix
      ./modules/home-manager.nix
    ];
    darwinBase = [
      ./base/darwin.nix
      ./modules/home-manager.nix
    ];

    inherit (nix-darwin.lib) darwinSystem;
    inherit (nixpkgs-unstable.lib) nixosSystem;
  in {
    nixosConfigurations.orion = nixosSystem {
      modules = nixosBase ++ [./machines/orion];
      specialArgs = getSpecialArgs {
        hostname = "orion";
        system = "x86_64-linux";
      };
    };

    nixosConfigurations.hydra = nixosSystem {
      modules = nixosBase ++ [./machines/hydra];
      specialArgs = getSpecialArgs {
        hostname = "hydra";
        system = "x86_64-linux";
      };
    };

    # liveboot ISO installer configuration
    nixosConfigurations.nebula = nixosSystem {
      modules = nixosBase ++ [./machines/nebula];
      specialArgs = getSpecialArgs {
        hostname = "nebula";
        system = "x86_64-linux";
      };
    };

    darwinConfigurations.pegasus = darwinSystem {
      modules = darwinBase ++ [./machines/pegasus];
      specialArgs = getSpecialArgs {
        hostname = "pegasus";
        system = "aarch64-darwin";
      };
    };

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

          shellHook = ''
            export PATH="$PATH:${./scripts}"
          '';
        };
      }
    );
  };
}
