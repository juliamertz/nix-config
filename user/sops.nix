{ pkgs, inputs, config, ...}:
let 
  profile = "personal";
  format = "yaml";
in {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops.defaultSopsFile = ../secrets/${profile}.${format};
  sops.defaultSopsFormat = format;
  sops.age.keyFile = "/home/julia/.config/sops/age/keys.txt";

  sops.secrets.zerotier_network_id = { };
  sops.secrets."zerotier_network_id" = {
    owner = "julia";
  };
}
