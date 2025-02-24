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
      url = "github:zhaofengli-wip/nix-homebrew";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
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
    sops-nix.url = "github:Mic92/sops-nix";
    dotfiles.url = "github:juliamertz/dotfiles";
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

    nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";
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
        { hostname, platform }:
        let
          pkgs = nixpkgs-unstable.legacyPackages.${platform};
          helpers = pkgs.callPackage ./helpers { inherit platform; };
          dotfiles = pkgs.callPackage ./helpers/dotfiles.nix {
            inherit platform;
            package = inputs.dotfiles;
            local = {
              enable = false;
              path = "${home}/dotfiles";
            };
          };

          homeDir = if helpers.isDarwin then "/Users" else "/home";
          home = "${homeDir}/${userSettings.username}";
        in
        {
          inherit inputs helpers dotfiles;
          settings = {
            user = userSettings // {
              inherit home;
            };
            system = {
              inherit hostname platform;
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
              platform = "x86_64-linux";
            };
            modules = base ++ [
              ./profiles/workstation
              ./hardware/workstation.nix
            ];
          };

          homelab = nixosSystem {
            specialArgs = getSpecialArgs {
              hostname = "homelab";
              platform = "x86_64-linux";
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
              platform = "x86_64-linux";
            };
            modules = [
              ./profiles/vps
              ./hardware/hetzner-cloud.nix
              ./profiles/base/nixos.nix
            ];
          };

        };

      darwinConfigurations = with nix-darwin.lib; {
        macbookpro = darwinSystem {
          specialArgs = getSpecialArgs {
            hostname = "macbookpro";
            platform = "aarch64-darwin";
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
