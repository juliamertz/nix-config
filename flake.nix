{
  description = "My nixos configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    suyu = {
      url = "git+https://git.suyu.dev/suyu/nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let 
      userSettings = {
        username = "julia";
      };

      systemSettings = {
        platform = "x86_64-linux";
      };

      lib = nixpkgs.lib;
      pkgs = nixpkgs.legacyPackages.${systemSettings.platform};
      settings = { user = userSettings; system = systemSettings; };
    in {
    nixosConfigurations = {
      workstation = lib.nixosSystem {
        system = systemSettings.platform;
        specialArgs = { 
          inherit inputs;
          inherit settings;
        };
        modules = [
          ./profiles/base.nix
          ./profiles/personal/configuration.nix
        ];
      };
    };
    homeConfigurations = {
      julia = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit inputs;
          inherit settings;
        };
        modules = [
          ./profiles/personal/home.nix
        ];
      };
    };
  };
}
