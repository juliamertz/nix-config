{
  pkgs,
  inputs,
  ...
}: {
  config = {
    services.desktopManager.cosmic.enable = true;

    nixpkgs.overlays = [
      (prev: final: {
        cosmic-comp = inputs.cosmic-comp.packages.${pkgs.system}.default.overrideAttrs {
          useXWayland = true;
        };
      })
    ];

    home-manager.users.julia = {
      imports = [
        inputs.cosmic-manager.homeManagerModules.cosmic-manager
      ];
    };
  };
}
