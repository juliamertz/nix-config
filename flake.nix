{
  description = "My nixos configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-24_05.url = "github:NixOS/nixpkgs/nixos-24.05";
    # nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-24.05-darwin";

    # affinity.url = "github:juliamertz/affinity-nixos/main";
    affinity = {
      url = "git+file:///home/julia/projects/2024/affinityCrimes/";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
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
    wezterm = {
      url = "github:wez/wezterm?dir=nix";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs-24_05";
    };
    flake-programs-sqlite = {
      url = "github:wamserma/flake-programs-sqlite";
      inputs.nixpkgs.follows = "nixpkgs";
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
      windowManager = "hyprland";
      home = "/home/${userSettings.username}";
      dotfiles = "${userSettings.home}/dotfiles";
    };

    systemSettings = {
      profile = "personal";
      hostname = "workstation";
      hardware =  systemSettings.hostname;

      term = "xterm-256color";
      platform = "x86_64-linux";
      timeZone = "Europe/Amsterdam";
      defaultLocale = "en_US.UTF-8";
    };

    dotfiles = pkgs.callPackage ./pkgs/dotfiles.nix {
      inherit pkgs; 
      repo = "https://github.com/juliamertz/dotfiles";
      rev = "e1086c71f9547471bfa4469be9406b317ed5bbab";
      local = {
        enable = true; # Enabling this will make the build impure.
        path = userSettings.dotfiles;
      };
    };

    lib = nixpkgs.lib;
    pkgs = nixpkgs.legacyPackages.${systemSettings.platform};
    settings = { user = userSettings; system = systemSettings; };

    pkgs-wrapped = pkgs.callPackage ./pkgs/wrappedPkgs {
      inherit pkgs;
      inherit inputs;
      inherit settings;
      configPath = dotfiles.path;
    };

    specialArgs = { 
      inherit inputs;
      inherit dotfiles;
      inherit settings;
      inherit pkgs-wrapped;
    };
  in {
    nixosConfigurations = {
      ${settings.system.hostname} = lib.nixosSystem {
        system = systemSettings.platform;
        inherit specialArgs;
        modules = [
          ./hardware-configuration.nix
          ./profiles/base.nix
          (./. + "/profiles" + ("/" + systemSettings.profile) + "/configuration.nix")
          (./. + "/user/wm" + ("/" + userSettings.windowManager) + "/configuration.nix")
          (./. + "/hardware" + ("/" + systemSettings.hardware) + ".nix")
          inputs.flake-programs-sqlite.nixosModules.programs-sqlite
        ];
      };
    };
    homeConfigurations = {
      ${settings.user.username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = specialArgs;
        modules = [
          (./. + "/profiles" + ("/" + systemSettings.profile) + "/home.nix")
          (./. + "/user/wm" + ("/" + userSettings.windowManager) + "/home.nix")
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
