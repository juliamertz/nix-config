{
  description = "My nixos configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-24_05.url = "github:NixOS/nixpkgs/nixos-24.05";

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

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let 
      userSettings = {
        username = "julia";
        fullName = "Julia Mertz";
        email = "info@juliamertz.dev";
        shell = "fish";
        browser = "firefox";
        terminal = "wezterm";
        windowManager = "awesome";
      };

      systemSettings = {
        profile = "personal";
        hostname = "workstation";
        hardware =  systemSettings.hostname;

        editor = "nvim";
        term = "xterm-256color";
        platform = "x86_64-linux";
        timeZone = "Europe/Amsterdam";
        defaultLocale = "en_US.UTF-8";
      };

      lib = nixpkgs.lib;
      pkgs = nixpkgs.legacyPackages.${systemSettings.platform};
      settings = { user = userSettings; system = systemSettings; };
    in {
    nixosConfigurations = {
      ${settings.system.hostname} = lib.nixosSystem {
        system = systemSettings.platform;
        specialArgs = { 
          inherit inputs;
          inherit settings;
        };
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
        extraSpecialArgs = {
          inherit inputs;
          inherit settings;
        };
        modules = [
          (./. + "/profiles" + ("/" + systemSettings.profile) + "/home.nix")
        ];
      };
    };
  };
}
