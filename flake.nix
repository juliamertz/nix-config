{
  description = "My nixos/nix-darwin configuration";

  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
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

    sops-nix.url = "github:Mic92/sops-nix";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    suyu = {
      url = "git+https://git.suyu.dev/suyu/nix-flake";
      inputs.nixpkgs.follows = "nixpkgs-24_05";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    cosmic.url = "github:lilyinstarlight/nixos-cosmic";
    spotify-player.url = "github:juliamertz/spotify-player/dev?dir=nix";
    protonvpn-rs.url = "github:juliamertz/protonvpn-rs/dev?dir=nix";
  };

  outputs =
    { nixpkgs-unstable, nix-darwin, ... }@inputs:
    let
      userSettings = {
        username = "julia";
        fullName = "Julia Mertz";
        email = "info@juliamertz.dev";
      };

      getSpecialArgs =
        { hostname, system }:
        let
          pkgs = nixpkgs-unstable.legacyPackages.${system};
          helpers = pkgs.callPackage ./helpers.nix { };
          dotfiles = {
            pkgs = inputs.dotfiles.packages.${system};
            path = "${inputs.dotfiles}";
          };

          homeDir = if helpers.isDarwin then "/Users" else "/home";
          home = "${homeDir}/${userSettings.username}";
        in
        {
          inherit
            inputs
            helpers
            dotfiles
            system
            ;
          settings = {
            user = userSettings // {
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
    in
    {
      nixosConfigurations =
        with nixpkgs-unstable.lib;
        let
          base = [
            ./profiles/base/nixos.nix
            ./modules/home-manager.nix
          ];
        in
        {
          workstation = nixosSystem {
            specialArgs = getSpecialArgs {
              hostname = "workstation";
              system = "x86_64-linux";
            };
            modules = base ++ [
              ./profiles/workstation
              ./hardware/workstation.nix
            ];
          };

          homelab = nixosSystem {
            specialArgs = getSpecialArgs {
              hostname = "homelab";
              system = "x86_64-linux";
            };
            modules = base ++ [
              ./profiles/homelab
              ./hardware/homelab.nix
            ];
          };

          # Use more stable branch for vps
          vps = inputs.nixpkgs-24_05.lib.nixosSystem {
            specialArgs = getSpecialArgs {
              hostname = "main";
              system = "x86_64-linux";
            };
            modules = [
              ./profiles/vps
              ./hardware/hetzner-cloud.nix
              ./profiles/base/nixos.nix
            ];
          };

          installerIso = nixosSystem {
            specialArgs = getSpecialArgs {
              hostname = "nixos-liveboot";
              system = "x86_64-linux";
            };
            modules = [ ./profiles/installer ];
          };

        };

      darwinConfigurations = with nix-darwin.lib; {
        macbookpro = darwinSystem {
          specialArgs = getSpecialArgs {
            hostname = "macbookpro";
            system = "aarch64-darwin";
          };
          modules = [
            ./profiles/laptop
            ./profiles/base/darwin.nix
            ./modules/home-manager.nix
          ];
        };
      };
    };
}
