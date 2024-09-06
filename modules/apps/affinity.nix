{ inputs, settings, ... }:
let
  path = "${settings.user.home}/affinity";
in
{
  imports = [ inputs.affinity.nixosModules.affinity ];

  affinity = {
    prefix = "${path}/prefix";
    user = settings.user.username;
    licenseViolations = "${path}/license_violations";

    photo.enable = true;
    designer.enable = true;
    publisher.enable = true;
  };
}
