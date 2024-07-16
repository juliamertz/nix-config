{
  description = "My nixos configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-24_05.url = "github:NixOS/nixpkgs/nixos-24.05";
# nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-24.05-darwin";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs-24_05";
    };
  };

  outputs = { self, nixpkgs, home-manager, nix-darwin, ... }@inputs:
    let 
      userSettings = {
        username = "julia";
        fullName = "Julia Mertz";
        email = "info@juliamertz.dev";
        shell = "fish";
        browser = "firefox";
        terminal = "wezterm";
        editor = "nvim";
        windowManager = "awesome";
        home = "/home/${userSettings.username}";
      };

  systemSettings = {
    profile = "laptop";
    hostname = "macbookpro";
    hardware =  systemSettings.hostname;

    term = "xterm-256color";
    platform = "aarch64-darwin";
    timeZone = "Europe/Amsterdam";
    defaultLocale = "en_US.UTF-8";
  };

  specialArgs = { 
    inherit inputs;
    inherit settings;
  };
  linuxSystems = [ "x86_64-linux" "aarch64-linux" ];
  darwinSystems = [ "aarch64-darwin" "x86_64-darwin" ];
  lib = nixpkgs.lib;
  pkgs = nixpkgs.legacyPackages.${systemSettings.platform};
  settings = { user = userSettings; system = systemSettings; };
  in {
    nixosConfigurations = {
      ${settings.system.hostname} = lib.nixosSystem {
        system = systemSettings.platform;
        inherit specialArgs;
        modules = [
          ./hardware-configuration.nix
            ./profiles/base.nix
            (./. + "/profiles" + ("/" + systemSettings.profile) + "/configuration.nix")
            (./. + "/hardware" + ("/" + systemSettings.hardware) + ".nix")
        ];
      };
    };
    homeConfigurations = {
      ${settings.user.username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = specialArgs;
        modules = [
          (./. + "/profiles" + ("/" + systemSettings.profile) + "/home.nix")
        ];
      };
    };
    darwinConfigurations.${settings.system.hostname} = nix-darwin.lib.darwinSystem {
      inherit specialArgs;
      modules = [ 
        ./profiles/laptop/configuration.nix 
        ./hardware/macbookpro.nix
      ];
    };
  };
}
