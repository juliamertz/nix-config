{ inputs, ... }:
let path = "${settings.user.home}/affinity";
in {
  imports = [ inputs.affinity.nixosModules.affinity ];

  affinity = {
    prefix = "${path}/prefix";
    licenseViolations = "${path}/license_violations";
    user = settings.user.username;

    photo.enable = true;
    designer.enable = true;
  };

}
