{
  inputs,
  helpers,
  ...
}:
let
  pkgs = helpers.getPkgs inputs.nixpkgs-unstable;
in
{
  nixpkgs.config = {
    packageOverrides = _: { inherit (pkgs) kdePackages; };
  };

  services.desktopManager.plasma6.enable = true;
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    konsole
    oxygen
  ];
}
