{
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.cosmic.nixosModules.default];

  config = {
    services.desktopManager.cosmic.enable = true;

    environment.cosmic.excludePackages = with pkgs; [
      cosmic-comp
    ];
    environment.systemPackages = [
      (inputs.cosmic-comp.packages.${pkgs.system}.default.overrideAttrs {useXWayland = false;})
    ];

    nix.settings = {
      substituters = ["https://cosmic.cachix.org/"];
      trusted-public-keys = ["cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="];
    };

    home-manager.users.julia = {
      imports = [
        inputs.cosmic-manager.homeManagerModules.cosmic-manager
      ];
    };
  };
}
