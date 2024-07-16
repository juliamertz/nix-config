{ pkgs, lib, inputs, settings, config, ... }:
let
  user = settings.user.username;
  platform = settings.system.platform;
  home-manager = inputs.home-manager.darwinModules.home-manager;
in {
  imports = [
    home-manager
  ];
  
  config = {
    services.nix-daemon.enable = true;
    environment.systemPackages = [
      inputs.nix-darwin
    ];

    users.users.${user} = {
      # home = "/Users/${user}";
      shell = "${pkgs.fish}/bin/fish";
    };

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = config._module.specialArgs;
      users.${user}  = {
        imports = [ 
          ./home.nix
        ];
        # home =
      };
    };
  };
}
